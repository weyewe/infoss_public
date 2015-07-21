class PurchaseDownPaymentAllocationDetail < ActiveRecord::Base
  belongs_to :purchase_down_payment_allocation
  belongs_to :payable
  has_many :purchase_down_payment_allocation_details
  validates_presence_of :payable_id
  validates_presence_of :purchase_down_payment_allocation_id
  
  validate :valid_purchase_down_payment_allocation
  validate :valid_payable
  
  def self.active_objects
    return self
  end
  
  def valid_purchase_down_payment_allocation
    return if  purchase_down_payment_allocation_id.nil?
    po = PurchaseDownPaymentAllocation.find_by_id purchase_down_payment_allocation_id
    if po.nil? 
      self.errors.add(:purchase_down_payment_allocation_id, "Harus ada purchase_down_payment_allocation_id")
      return self 
    end
  end 
    
  def valid_payable
    return if  payable_id.nil?
    pyb = Payable.find_by_id payable_id
    if pyb.nil? 
      self.errors.add(:payable_id, "Harus ada Payable Id")
      return self 
    end
    
    itemcount = PurchaseDownPaymentAllocationDetail.where(
      :payable_id => payable_id,
      :purchase_down_payment_allocation_id => purchase_down_payment_allocation_id,
      ).count  
    
    if self.persisted?
       if itemcount > 1
         self.errors.add(:payable_id, "Payable sudah terpakai")
      return self 
       end
    else
       if itemcount > 0
         self.errors.add(:payable_id, "Payable sudah terpakai")
      return self 
       end
    end
  end   
  
  def self.create_object(params)
    new_object = self.new
    new_object.purchase_down_payment_allocation_id = params[:purchase_down_payment_allocation_id]
    new_object.payable_id = params[:payable_id]
    new_object.description = params[:description]
    new_object.amount_paid = BigDecimal( params[:amount_paid] )
    new_object.rate = BigDecimal( params[:rate] )
    new_object.amount = (BigDecimal( params[:amount_paid]) / BigDecimal( params[:rate]))
    if new_object.save
    new_object.code = "PDAPD-" + new_object.id.to_s  
    new_object.save
    new_object.calculateTotalAmount
    end
    return new_object
  end                   
  
  def update_object(params)
    if self.purchase_down_payment_allocation.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.payable_id = params[:payable_id]
    self.description = params[:description]
    self.amount_paid = BigDecimal( params[:amount_paid] )
    self.rate = BigDecimal( params[:rate] )
    self.amount = (BigDecimal( params[:amount_paid]) / BigDecimal( params[:rate]))
    if self.save
      self.calculateTotalAmount
    end
    return self
  
  end
  
  def calculateTotalAmount
    amount = 0
    PurchaseDownPaymentAllocationDetail.where(:purchase_down_payment_allocation_id => purchase_down_payment_allocation_id).each do |pdad|
      amount += pdad.amount_paid
    end
    purchase_down_payment_allocation = PurchaseDownPaymentAllocation.find_by_id(purchase_down_payment_allocation_id)
    purchase_down_payment_allocation.update_amount(amount)
  end
  
end
