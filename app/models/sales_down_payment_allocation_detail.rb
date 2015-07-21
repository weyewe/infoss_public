class SalesDownPaymentAllocationDetail < ActiveRecord::Base
  belongs_to :sales_down_payment_allocation
  belongs_to :receivable
  has_many :sales_down_payment_allocation_details
  validates_presence_of :receivable_id
  validates_presence_of :sales_down_payment_allocation_id
  
  validate :valid_sales_down_payment_allocation
  validate :valid_receivable
  
  def self.active_objects
    return self
  end
  
  def valid_sales_down_payment_allocation
    return if  sales_down_payment_allocation_id.nil?
    po = SalesDownPaymentAllocation.find_by_id sales_down_payment_allocation_id
    if po.nil? 
      self.errors.add(:sales_down_payment_allocation_id, "Harus ada sales_down_payment_allocation_id")
      return self 
    end
  end 
    
  def valid_receivable
    return if  receivable_id.nil?
    pyb = Receivable.find_by_id receivable_id
    if pyb.nil? 
      self.errors.add(:receivable_id, "Harus ada Receivable Id")
      return self 
    end
    
    itemcount = SalesDownPaymentAllocationDetail.where(
      :receivable_id => receivable_id,
      :sales_down_payment_allocation_id => sales_down_payment_allocation_id,
      ).count  
    
    if self.persisted?
       if itemcount > 1
         self.errors.add(:receivable_id, "Receivable sudah terpakai")
      return self 
       end
    else
       if itemcount > 0
         self.errors.add(:receivable_id, "Receivable sudah terpakai")
      return self 
       end
    end
  end   
  
  def self.create_object(params)
    new_object = self.new
    new_object.sales_down_payment_allocation_id = params[:sales_down_payment_allocation_id]
    new_object.receivable_id = params[:receivable_id]
    new_object.description = params[:description]
    new_object.amount_paid = BigDecimal( params[:amount_paid] )
    new_object.rate = BigDecimal( params[:rate] )
    new_object.amount = (BigDecimal( params[:amount_paid]) / BigDecimal( params[:rate]))
    if new_object.save
    new_object.code = "SDPAD-" + new_object.id.to_s  
    new_object.save
    new_object.calculateTotalAmount
    end
    return new_object
  end                   
  
  def update_object(params)
    if self.sales_down_payment_allocation.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.receivable_id = params[:receivable_id]
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
    SalesDownPaymentAllocationDetail.where(:sales_down_payment_allocation_id => sales_down_payment_allocation_id).each do |pdad|
      amount += pdad.amount_paid
    end
    sales_down_payment_allocation = SalesDownPaymentAllocation.find_by_id(sales_down_payment_allocation_id)
    sales_down_payment_allocation.update_amount(amount)
  end
end
