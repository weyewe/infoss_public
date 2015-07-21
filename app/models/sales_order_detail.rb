class SalesOrderDetail < ActiveRecord::Base
  validates_presence_of :item_id
 
  validate :valid_sales_order
  validate :valid_item
  validate :valid_amount
  belongs_to :sales_order
  belongs_to :item
  
  def self.active_objects
    self
  end
  
  def valid_amount
    if amount <= BigDecimal("0")
      self.errors.add(:amount, "Harus lebih besar dari 0")
      return self
    end
  end
  
  def valid_sales_order
    return if  sales_order_id.nil?
    po = SalesOrder.find_by_id sales_order_id
    if po.nil? 
      self.errors.add(:sales_order_id, "Harus ada SalesOrder_id")
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
    
    itemcount = SalesOrderDetail.where(
      :item_id => item_id,
      :sales_order_id => sales_order_id,
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
  
  def self.create_object(params)
    new_object = self.new
    sales_order = SalesOrder.find_by_id(params[:sales_order_id])
    if not sales_order.nil?
      if sales_order.is_confirmed?
        new_object.errors.add(:generic_errors, "Sudah di konfirmasi")
        return new_object 
      end
    end
    
    new_object.sales_order_id = params[:sales_order_id]
    new_object.item_id = params[:item_id]
    new_object.is_service = params[:is_service]
    new_object.amount = BigDecimal( params[:amount] || '0')
    new_object.pending_delivery_amount = BigDecimal( params[:amount] || '0')
    new_object.price = BigDecimal( params[:price] || '0')
    if new_object.save
      new_object.code = "SOD-" + new_object.id.to_s  
      new_object.pending_delivery_amount  = new_object.amount
      new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    if self.sales_order.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.item_id = params[:item_id]
    self.amount = BigDecimal( params[:amount] || '0') 
    self.price = BigDecimal( params[:price] || '0')
    self.save
    return self
  end
  
  def delete_object
    if self.sales_order.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.destroy
    return self
  end
  
  
  
end
