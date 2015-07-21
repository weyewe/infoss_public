class SalesInvoice < ActiveRecord::Base
  
  belongs_to :exchange
  belongs_to :exchange_rate
  belongs_to :delivery_order
  has_many :sales_invoice_details
#   validates_presence_of :exchange_id
  validates_presence_of :nomor_surat
  validates_presence_of :invoice_date
  validates_presence_of :delivery_order_id
 
  
#   validate :valid_exchange_id

  validate :valid_delivery_order_id
  
  
  def self.active_objects
    self
  end
  
  def active_children
    self.sales_invoice_details 
  end
  
  def valid_delivery_order_id
    return if  delivery_order_id.nil?
    pr = DeliveryOrder.find_by_id delivery_order_id
    if pr.nil? 
      self.errors.add(:delivery_order_id, "Harus ada delivery_order_id")
      return self 
    end
  end

  def valid_exchange_id
    return if  exchange_id.nil?
    ec = Exchange.find_by_id exchange_id
    if ec.nil? 
      self.errors.add(:exchange_id, "Harus ada Exchange Id")
      return self 
    end
  end    
  
  def self.create_object( params )
    new_object = self.new
    new_object.delivery_order_id = params[:delivery_order_id]
    new_object.invoice_date = params[:invoice_date]
    new_object.nomor_surat = params[:nomor_surat]
    new_object.description = params[:description]
    new_object.due_date = params[:due_date]
    if new_object.save  
      new_object.exchange_id = new_object.delivery_order.sales_order.exchange_id
      new_object.code = "SI-" + new_object.id.to_s  
      new_object.save
    end
    return new_object
  end
  
  def update_object( params ) 
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    if self.sales_invoice_details.count > 0
      self.errors.add(:generic_errors, "Sudah memiliki detail")
      return self 
    end
    self.delivery_order_id = params[:delivery_order_id]
    self.invoice_date = params[:invoice_date]
    self.nomor_surat = params[:nomor_surat]
    self.description = params[:description]
    self.due_date = params[:due_date]
    if self.save 
    self.exchange_id = self.delivery_order.sales_order.exchange_id
    self.save
    end
    return self
  end
    
  def confirm_object( params )  
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    
    if self.sales_invoice_details.count == 0
      self.errors.add(:generic_errors, "Tidak memiliki detail")
      return self 
    end
    
    if params[:confirmed_at].nil?
      self.errors.add(:generic_errors, "Harus ada tanggal konfirmasi")
      return self 
    end    
    if Closing.is_date_closed(self.invoice_date).count > 0 
      self.errors.add(:generic_errors, "Period sudah di closing")
      return self 
    end
    if self.delivery_order.sales_order.exchange.is_base == false 
      latest_exchange_rate = ExchangeRate.get_latest(
        :ex_rate_date => self.invoice_date,
        :exchange_id => self.exchange_id
        )
      self.exchange_rate_amount = latest_exchange_rate.rate
      self.exchange_rate_id = latest_exchange_rate.id
    else
      self.exchange_rate_amount = 1
    end
    
    self.confirmed_at = params[:confirmed_at]
    self.is_confirmed = true  
    
    if self.save 
      self.update_sales_invoice_confirm
      AccountingService::CreateSalesInvoiceJournal.create_confirmation_journal(self)
      self.generate_receivable  
    end
    return self 
  end
  
  def unconfirm_object
    if not self.is_confirmed?
      self.errors.add(:generic_errors, "belum di konfirmasi")
      return self 
    end
    if Closing.is_date_closed(self.invoice_date).count > 0 
      self.errors.add(:generic_errors, "Period sudah di closing")
      return self 
    end
    siclass = self.class.to_s
    siid = self.id
    receipt_voucher_count = ReceiptVoucherDetail.joins(:receivable).where{
      ( 
        (receivable.source_class.eq siclass) &
        (receivable.source_id.eq siid) 
      )
      }.count
    if receipt_voucher_count > 0
      self.errors.add(:generic_errors, "Sudah terpakai di ReceiptVoucher")
      return self
    end
    
    
    self.is_confirmed = false
    self.confirmed_at = nil 
    if self.save
      self.delete_receivable
      self.update_sales_invoice_unconfirm
      AccountingService::CreateSalesInvoiceJournal.undo_create_confirmation_journal(self)
    end
    return self
  end
   
  
  def delete_object
    if self.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    
    if self.sales_invoice_details.count > 0
      self.errors.add(:generic_errors, "Sudah memiliki detail")
      return self 
    end
    
    self.destroy
    return self
  end
  
  # def update_amount_receivable(amount)
  #   self.amount_receivable = amount
  #   tax_value = 0
  #   case self.delivery_order.sales_order.contact.tax_code # a_variable is the variable we want to compare
  #   when TAX_CODE[:code_01]  
  #     tax_value = TAX_VALUE[:code_01]
  #   when TAX_CODE[:code_02] 
  #     tax_value = TAX_VALUE[:code_02]
  #   when TAX_CODE[:code_03] 
  #     tax_value = TAX_VALUE[:code_03]
  #   when TAX_CODE[:code_04] 
  #     tax_value = TAX_VALUE[:code_04]
  #   when TAX_CODE[:code_05] 
  #     tax_value = TAX_VALUE[:code_05]
  #   when TAX_CODE[:code_06] 
  #     tax_value = TAX_VALUE[:code_06]
  #   when TAX_CODE[:code_07] 
  #     tax_value = TAX_VALUE[:code_07]
  #   when TAX_CODE[:code_08] 
  #     tax_value = TAX_VALUE[:code_08]
  #   when TAX_CODE[:code_09] 
  #     tax_value = TAX_VALUE[:code_09]
  #   end
  #   self.tax = amount * tax_value / 100
  #   self.save
  # end
  
  
  
  def generate_receivable
    Receivable.create_object(
      :source_class => self.class.to_s, 
      :source_id => self.id ,  
      :contact_id => self.delivery_order.sales_order.contact_id,
      :amount => self.amount_receivable ,  
      :due_date => self.due_date ,  
      :exchange_id => self.exchange_id,
      :exchange_rate_amount => self.exchange_rate_amount,
      :source_code => self.code
    ) 
  end
  
  def delete_receivable
    rcb = Receivable.where(
      :source_id =>self.id,
      :source_class => self.class.to_s, 
      )
    rcb.each do |x|
     x.delete_object
    end
  end 
 
  
  def update_sales_invoice_confirm
    total_cos = 0
    self.sales_invoice_details.each do |sid|
      
      # TODO set detail.cos
      total_cos += sid.cos
      sid.delivery_order_detail.pending_invoiced_amount -= sid.amount
      if sid.delivery_order_detail.pending_invoiced_amount == 0 
         sid.delivery_order_detail.is_all_invoiced == true
      end
      sid.delivery_order_detail.save
    end
      self.total_cos = total_cos
      self.save
      self.delivery_order.update_is_invoice_completed
  end
  
  def update_sales_invoice_unconfirm
    self.sales_invoice_details.each do |sid|
      sid.delivery_order_detail.pending_invoiced_amount += sid.amount
      sid.delivery_order_detail.is_all_invoiced == false
      sid.delivery_order_detail.save
    end
      self.delivery_order.update_is_invoice_completed
  end
  
  
  
end
