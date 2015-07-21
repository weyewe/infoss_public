class PurchaseDownPayment < ActiveRecord::Base
  belongs_to :contact
  belongs_to :exchange
  belongs_to :receivable
  belongs_to :payable
  validates_presence_of :contact_id
  validates_presence_of :exchange_id
  validates_presence_of :down_payment_date
  validates_presence_of :due_date
  validates_presence_of :total_amount
 
  
  validate :valid_contact_id 
  validate :valid_exchange_id
    
  def self.active_objects
    self
  end
  
  def active_children
    self.purchase_down_payment_allocation_details 
  end
  
  def valid_contact_id
    return if  contact_id.nil?
    
    co = Contact.find_by_id contact_id
    
    if co.nil? 
      self.errors.add(:contact_id, "Harus ada Contact Id")
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
    new_object.contact_id = params[:contact_id]
    new_object.exchange_id = params[:exchange_id]
    new_object.down_payment_date = params[:down_payment_date]
    new_object.due_date = params[:due_date]
    new_object.total_amount = BigDecimal( params[:total_amount] || '0')
    if new_object.save
    new_object.code = "PDP-" + new_object.id.to_s  
    new_object.save
    end
    return new_object
  end
    
  def update_object(params)
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    self.contact_id = params[:contact_id]
    self.exchange_id = params[:exchange_id]
    self.down_payment_date = params[:down_payment_date]
    self.due_date = params[:due_date]
    self.total_amount = BigDecimal( params[:total_amount] || '0')
    if self.save
    end
    return self
  end
  
  def delete_object
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    self.destroy
    return self
  end
    
  def confirm_object(params)
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    if Closing.is_date_closed(self.down_payment_date).count > 0 
      self.errors.add(:generic_errors, "Period sudah di closing")
      return self 
    end
    self.is_confirmed = true
    self.confirmed_at = params[:confirmed_at]
    if self.save
      # set exchange_rate_amount
      if self.exchange.is_base == false 
        latest_exchange_rate = ExchangeRate.get_latest(
          :ex_rate_date => self.down_payment_date,
          :exchange_id => self.exchange_id
          )
        self.exchange_rate_amount = latest_exchange_rate.rate
        self.exchange_rate_id = latest_exchange_rate.id
      else
        self.exchange_rate_amount = 1
      end
      # genereate receivable & set receivable_id
        self.receivable_id = self.generate_receivable.id
      # generate payable & set payable_id
        self.payable_id =  self.generate_payable.id
        self.save
      # generate journal
      AccountingService::CreatePurchaseDownPaymentJournal.create_confirmation_journal(self)  
    end
  end
  
  def unconfirm_object
    if not self.is_confirmed?
      self.errors.add(:generic_errors, "Belum di konfirmasi")
      return self
    end
    if self.payable.remaining_amount < self.payable.amount
      self.errors.add(:generic_errors, "Payable tidak boleh sudah diuangkan")
      return self
    end
    if Closing.is_date_closed(self.down_payment_date).count > 0 
      self.errors.add(:generic_errors, "Period sudah di closing")
      return self 
    end
    self.is_confirmed = false
    self.confirmed_at = nil
    if self.save
      # delete payable & set payable_id 
      self.delete_payable
      self.payable_id = nil
      # delete receivable & set receivable_id
      self.delete_receivable
      self.receivable_id = nil
      self.save
      # genereate sales_down_payment_journal
      AccountingService::CreateSalesDownPaymentJournal.undo_create_confirmation_journal(self) 
    end
    return self
  end
  
  def generate_receivable
    rcb = Receivable.create_object(
      :source_class => self.class.to_s, 
      :source_id => self.id ,  
      :contact_id => self.contact_id,
      :amount => self.total_amount ,  
      :due_date => self.due_date ,  
      :exchange_id => self.exchange_id,
      :exchange_rate_amount => self.exchange_rate_amount,
      :source_code => self.code
    ) 
    return rcb
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
  
  def generate_payable
    pyb = Payable.create_object(
      :source_class => self.class.to_s, 
      :source_id => self.id ,  
      :contact_id => self.contact_id,
      :amount => self.total_amount ,  
      :due_date => self.due_date ,  
      :exchange_id => self.exchange_id,
      :exchange_rate_amount => self.exchange_rate_amount,
      :source_code => self.code
    ) 
    return pyb
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
end
