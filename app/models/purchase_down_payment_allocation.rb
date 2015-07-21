class PurchaseDownPaymentAllocation < ActiveRecord::Base
  belongs_to :contact
  belongs_to :receivable
  has_many :purchase_down_payment_allocation_details
  validates_presence_of :contact_id
  validates_presence_of :allocation_date
  
  validate :valid_contact_id 
  validate :valid_receivable
  
  def valid_receivable
    return if  receivable_id.nil?
    
    co = Receivable.find_by_id receivable_id
    
    if co.nil? 
      self.errors.add(:receivable_id, "Harus ada Receivable Id")
      return self 
    end
  end
  
  
  
  def valid_contact_id
    return if  contact_id.nil?
    
    co = Contact.find_by_id contact_id
    
    if co.nil? 
      self.errors.add(:contact_id, "Harus ada Contact Id")
      return self 
    end
  end
  
  def self.active_objects
    self
  end
  
  def active_children
    self.purchase_down_payment_allocation_details 
  end
  
  def self.create_object(params)
    new_object = self.new
    new_object.contact_id = params[:contact_id]
    new_object.receivable_id = params[:receivable_id]
    new_object.allocation_date = params[:allocation_date]
    new_object.rate_to_idr = BigDecimal( params[:rate_to_idr] || '0')
    new_object.total_amount = 0
    if new_object.save
    new_object.code = "PDPA-" + new_object.id.to_s  
    new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    if self.purchase_down_payment_allocation_details.count > 0 
      self.errors.add(:generic_errors, "Sudah memiliki detail")
      return self 
    end
    self.contact_id = params[:contact_id]
    self.receivable_id = params[:receivable_id]
    self.allocation_date = params[:allocation_date]
    self.rate_to_idr = BigDecimal( params[:rate_to_idr] || '0')
    self.total_amount = 0
    if self.save
    end
    return self
  end
  
  def update_amount(amount)
    self.total_amount = amount
    self.save
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
    if Closing.is_date_closed(self.allocation_date).count > 0 
      self.errors.add(:generic_errors, "Period sudah di closing")
      return self 
    end
    self.is_confirmed = true
    self.confirmed_at = params[:confirmed_at]
    if self.save
      self.purchase_down_payment_allocation_details.each do |pdpad|
        self.receivable.remaining_amount -= pdpad.amount_paid
        pdpad.payable.remaining_amount -= pdpad.amount
      end
      # update receivable remaining amount
      AccountingService::CreatePurchaseDownPaymentAllocationJournal.create_confirmation_journal(self) 
    end
  end
  
  def unconfirm_object
    if not self.is_confirmed?
      self.errors.add(:generic_errors, "Belum di konfirmasi")
      return self
    end
    if Closing.is_date_closed(self.allocation_date).count > 0 
      self.errors.add(:generic_errors, "Period sudah di closing")
      return self 
    end
    self.is_confirmed = false
    self.confirmed_at = nil
    if self.save
      self.purchase_down_payment_allocation_details.each do |pdpad|
        self.receivable.remaining_amount += pdpad.amount_paid
        pdpad.payable.remaining_amount += pdpad.amount
      end
      AccountingService::CreatePurchaseDownPaymentAllocationJournal.undo_create_confirmation_journal(self) 
    end
  end
  
  
end
