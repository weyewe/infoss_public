class PurchaseInvoice < ActiveRecord::Base
  
  belongs_to :exchange
  belongs_to :exchange_rate
  belongs_to :purchase_receival
  has_many :purchase_invoice_details
#   validates_presence_of :exchange_id
  validates_presence_of :nomor_surat
  validates_presence_of :invoice_date
  validates_presence_of :purchase_receival_id
 
  
#   validate :valid_exchange_id

  validate :valid_purchase_receival_id
  
  
  def self.active_objects
    self
  end
  
  def active_children
    self.purchase_invoice_details 
  end
  
  def valid_purchase_receival_id
    return if  purchase_receival_id.nil?
    pr = PurchaseReceival.find_by_id purchase_receival_id
    if pr.nil? 
      self.errors.add(:purchase_receival_id, "Harus ada purchase_receival_id")
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
    new_object.purchase_receival_id = params[:purchase_receival_id]
    new_object.invoice_date = params[:invoice_date]
    new_object.nomor_surat = params[:nomor_surat]
    new_object.description = params[:description]
    new_object.due_date = params[:due_date]
    if new_object.save  
    new_object.exchange_id = new_object.purchase_receival.purchase_order.exchange_id
    new_object.is_taxable =  new_object.purchase_receival.purchase_order.contact.is_taxable   
    new_object.code = "PI-" + new_object.id.to_s  
    new_object.save
    end
    return new_object
  end
  
  def update_object( params ) 
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    if self.purchase_invoice_details.count > 0
      self.errors.add(:generic_errors, "Sudah memiliki detail")
      return self 
    end
    self.purchase_receival_id = params[:purchase_receival_id]
    self.invoice_date = params[:invoice_date]
    self.nomor_surat = params[:nomor_surat]
    self.description = params[:description]
    self.due_date = params[:due_date]
    if self.save 
      
    self.exchange_id = self.purchase_receival.purchase_order.exchange_id
    self.is_taxable =  self.purchase_receival.purchase_order.contact.is_taxable   
      self.save
    end
    return self
  end
    
  def confirm_object( params )  
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    
    if self.purchase_invoice_details.count == 0
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
    if self.purchase_receival.purchase_order.exchange.is_base == false 
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
       
      self.update_purchase_invoice_confirm
       self.generate_payable  
      AccountingService::CreatePurchaseInvoiceJournal.create_confirmation_journal(self)
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
    piclass = self.class.to_s
    piid = self.id
    payment_voucher_count = PaymentVoucherDetail.joins(:payable).where{
      (
        (payable.source_class.eq piclass) &
        (payable.source_id.eq piid)
      )
      }.count
    if payment_voucher_count > 0
      self.errors.add(:generic_errors, "Sudah terpakai di PaymentVoucher")
      return self
    end
    
    
    self.is_confirmed = false
    self.confirmed_at = nil 
    if self.save
      self.delete_payable
      self.update_purchase_invoice_unconfirm
      AccountingService::CreatePurchaseInvoiceJournal.undo_create_confirmation_journal(self)
    end
    return self
  end
   
  
  def delete_object
    if self.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    
    if self.purchase_invoice_details.count > 0
      self.errors.add(:generic_errors, "Sudah memiliki detail")
      return self 
    end
    
    self.destroy
    return self
  end
  
  def update_amount_payable(amount)
    self.amount_payable = amount
    if self.is_taxable = true
      tax_value = 0
      case self.purchase_receival.purchase_order.contact.tax_code # a_variable is the variable we want to compare
      when TAX_CODE[:code_01]  
        tax_value = TAX_VALUE[:code_01]
      when TAX_CODE[:code_02] 
        tax_value = TAX_VALUE[:code_02]
      when TAX_CODE[:code_03] 
        tax_value = TAX_VALUE[:code_03]
      when TAX_CODE[:code_04] 
        tax_value = TAX_VALUE[:code_04]
      when TAX_CODE[:code_05] 
        tax_value = TAX_VALUE[:code_05]
      when TAX_CODE[:code_06] 
        tax_value = TAX_VALUE[:code_06]
      when TAX_CODE[:code_07] 
        tax_value = TAX_VALUE[:code_07]
      when TAX_CODE[:code_08] 
        tax_value = TAX_VALUE[:code_08]
      when TAX_CODE[:code_09] 
        tax_value = TAX_VALUE[:code_09]
      end
      self.tax = tax_value
      self.amount_payable += amount * tax_value / 100
    end
    self.save
    return self
  end
  
  
  
  def generate_payable
    Payable.create_object(
      :source_class => self.class.to_s, 
      :source_id => self.id ,  
      :contact_id => self.purchase_receival.purchase_order.contact_id,
      :amount => self.amount_payable ,  
      :due_date => self.due_date ,  
      :exchange_id => self.exchange_id,
      :exchange_rate_amount => self.exchange_rate_amount,
      :source_code => self.code
    ) 
  end
  
  def delete_payable
    pyb = Payable.where(
      :source_id =>self.id,
      :source_class => self.class.to_s, 
      )
    pyb.each do |x|
     x.delete_object
    end
  end 
 
  
  def update_purchase_invoice_confirm
    self.purchase_invoice_details.each do |pid|
      pid.purchase_receival_detail.pending_invoiced_amount -= pid.amount
      if pid.purchase_receival_detail.pending_invoiced_amount == 0 
         pid.purchase_receival_detail.is_all_invoiced == true
      end
      pid.purchase_receival_detail.save
    end
      self.purchase_receival.update_is_invoice_completed
  end
  
  def update_purchase_invoice_unconfirm
    self.purchase_invoice_details.each do |pid|
      pid.purchase_receival_detail.pending_invoiced_amount += pid.amount
      pid.purchase_receival_detail.is_all_invoiced == false
      pid.purchase_receival_detail.save
    end
      self.purchase_receival.update_is_invoice_completed
  end
  
  
  
end
