class PaymentRequest < ActiveRecord::Base
  has_many :payment_request_details
  belongs_to :account
  belongs_to :exchange
  belongs_to :contact
  validates_presence_of :contact_id
  validates_presence_of :request_date
  validates_presence_of :due_date
   
  validate :valid_contact
  validate :valid_account
  
  def self.active_objects
    return self
  end
  
  def active_children
    return self.payment_request_details
  end
  
  def valid_contact
    return if contact_id.nil? 
    contact = Contact.find_by_id(contact_id)
    if contact.nil?
      self.errors.add(:contact_id, "Harus ada contact Id")
      return self
    end
  end
  
  def valid_account
    return if account_id.nil? 
    coa = Account.find_by_id(account_id)
    if coa.nil?
      self.errors.add(:account_id, "Harus ada Account Id")
      return self
    end
  end
  
  def self.create_object(params)
    new_object = self.new
    new_object.contact_id = params[:contact_id]
    new_object.request_date = params[:request_date]
    new_object.no_bukti = params[:no_bukti]
    new_object.due_date = params[:due_date]
    new_object.account_id = params[:account_id]
    if new_object.save
      new_object.code = "PR-" + new_object.id.to_s
      new_object.exchange_id = new_object.account.exchange.id
      new_object.save
    end
    return new_object
  end
  
  def update_object( params ) 
    
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    
    if self.payment_request_details.count > 0
      self.errors.add(:generic_errors, "memiliki detail")
      return self 
    end
    
    self.contact_id = params[:contact_id]
    self.request_date = params[:request_date]
    self.due_date = params[:due_date]
    self.no_bukti = params[:no_bukti]
    self.account_id = params[:account_id]
    if self.save
      self.exchange_id = self.account.exchange.id
      self.save
    end
    return self
  end
   
  
  def generate_payable
    Payable.create_object(
      :source_class => self.class.to_s, 
      :source_id => self.id ,  
      :contact_id => self.contact_id,
      :amount => self.amount ,  
      :due_date => self.due_date ,  
      :exchange_id => self.exchange_id,
      :exchange_rate_amount => self.exchange_rate_amount,
      :source_code => self.code
      )
  end
  
  def delete_payable
    rvl = Payable.where(
      :source_id =>self.id,
      :source_class => self.class.to_s, 
      )
    rvl.each do |x|
     x.delete_object
    end
  end

  
  def confirm_object(params)
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    if Closing.is_date_closed(self.request_date).count > 0 
      self.errors.add(:generic_errors, "Period sudah di closing")
      return self 
    end
    if self.payment_request_details.count == 0
      self.errors.add(:generic_errors, "Tidak memiliki detail")
      return self 
    end
   
    if self.exchange.is_base == false 
      latest_exchange_rate = ExchangeRate.get_latest(
        :ex_rate_date => self.request_date,
        :exchange_id => self.exchange_id
        )
      self.exchange_rate_amount = latest_exchange_rate.rate
      self.exchange_rate_id = latest_exchange_rate.id   
    else
      self.exchange_rate_amount = 1
    end
    self.is_confirmed = true
    self.confirmed_at = params[:confirmed_at]
    if self.save  
      self.generate_payable 
      AccountingService::CreatePaymentRequestJournal.create_confirmation_journal(self)
    end
    return self
  end
  
  def unconfirm_object
    if not self.is_confirmed?
      self.errors.add(:generic_errors, "belum di konfirmasi")
      return self 
    end
    if Closing.is_date_closed(self.request_date).count > 0 
      self.errors.add(:generic_errors, "Period sudah di closing")
      return self 
    end
    prclass = self.class.to_s
    prid = self.id
    payment_voucher_count = PaymentVoucherDetail.joins(:payable).where{
      (
        (payable.source_class.eq prclass) &
        (payable.source_id.eq prid)
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
      AccountingService::CreatePaymentRequestJournal.undo_create_confirmation_journal(self)
    end
    return self
  end
  
  def delete_object
    if self.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
 
    if self.payment_request_details.count > 0
      self.errors.add(:generic_errors, "memiliki detail")
      return self 
    end
    
    self.destroy
    return self
  end
  
  def update_amount(amount)
    self.amount = amount
    self.save
    return self
  end
  
end
