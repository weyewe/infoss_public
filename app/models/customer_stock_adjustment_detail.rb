class CustomerStockAdjustmentDetail < ActiveRecord::Base
 
  validates_presence_of :item_id
  validate :valid_customer_stock_adjustment
  validate :valid_item
  validate :valid_price_and_amount
  validate :valid_adjustment_status
  belongs_to :customer_stock_adjustment
  belongs_to :item
  
  def self.active_objects
    self
  end
    
  def valid_adjustment_status
    return if status.nil? 
    if not  [
      ADJUSTMENT_STATUS[:addition],
      ADJUSTMENT_STATUS[:deduction]
      ].include?( status.to_i )
      self.errors.add(:status, "Harus memilih status")
      return self 
    end
  end
  
  
  def valid_price_and_amount
    return if price.nil? or amount.nil?
    if price <= BigDecimal("0")
      self.errors.add(:price, "Harus lebih besar dari 0")
      return self
    end
    if amount <= BigDecimal("0")
      self.errors.add(:amount, "Harus lebih besar dari 0")
      return self
    end
  end
  
  def valid_customer_stock_adjustment
    return if  customer_stock_adjustment_id.nil?
    sa = CustomerStockAdjustment.find_by_id customer_stock_adjustment_id
    if sa.nil? 
      self.errors.add(:customer_stock_adjustment_id, "Harus ada CustomerStockAdjustment_Id")
      return self 
    end
  end 
    
  def valid_item
    return if  item_id.nil?
    item = Item.find_by_id item_id
    if item.nil? 
      self.errors.add(:item_id, "Harus ada Item_Id")
      return self 
    end
    
    itemcount = CustomerStockAdjustmentDetail.where(
      :item_id => item_id,
      :customer_stock_adjustment_id => customer_stock_adjustment_id,
      ).count  
    
    if self.persisted?
       if itemcount > 1
         self.errors.add(:item_id, "Item sudah terpakai")
      return self 
       end
    else
       if itemcount > 0
         self.errors.add(:item_id, "Item sudah terpakai")
      return self 
       end
    end
  end 
  
  def calculateTotalAmount
    total = 0
    CustomerStockAdjustmentDetail.where(:customer_stock_adjustment_id =>customer_stock_adjustment_id).each do |sad|
      total += sad.price * sad.amount
    end
    CustomerStockAdjustment.find_by_id(customer_stock_adjustment_id).update_total(total)
  end
  
  def self.create_object(params)
    new_object = self.new
    new_object.customer_stock_adjustment_id = params[:customer_stock_adjustment_id]
    new_object.item_id = params[:item_id]
    new_object.price = params[:price]
    new_object.amount = params[:amount]
    new_object.status = params[:status]
    if new_object.save
      new_object.code = "SadjD-" + new_object.id.to_s  
      new_object.calculateTotalAmount
      new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    if self.customer_stock_adjustment.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.item_id = params[:item_id]
    self.price = params[:price]
    self.amount = params[:amount]
    self.status = params[:status]
    if self.save
      self.calculateTotalAmount
    end
    return self
  end
  
  def delete_object
    if self.customer_stock_adjustment.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.destroy
    return self
  end
end
