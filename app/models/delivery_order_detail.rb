class DeliveryOrderDetail < ActiveRecord::Base
  
  validates_presence_of :sales_order_detail_id
 
  validate :valid_delivery_order
  validate :valid_sales_order_detail
  validate :valid_amount
  belongs_to :delivery_order
  belongs_to :sales_order_detail
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
  
  def valid_delivery_order
    return if  delivery_order_id.nil?
    pr = DeliveryOrder.find_by_id delivery_order_id
    if pr.nil? 
      self.errors.add(:delivery_order_id, "Harus ada delivery_order_id")
      return self 
    end
  end 
    
  def valid_sales_order_detail
    return if  sales_order_detail_id.nil?
    pod = SalesOrderDetail.find_by_id sales_order_detail_id
    if pod.nil? 
      self.errors.add(:item_id, "Harus ada sales_order_detail_id")
      return self 
    end
    
    itemcount = DeliveryOrderDetail.where(
      :sales_order_detail_id => sales_order_detail_id,
      :delivery_order_id => delivery_order_id,
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
    delivery_order = DeliveryOrder.find_by_id(params[:delivery_order_id])
    if not delivery_order.nil?
      if delivery_order.is_confirmed?
        new_object.errors.add(:generic_errors, "Sudah di konfirmasi")
        return new_object 
      end
    end
    new_object.delivery_order_id = params[:delivery_order_id]
    new_object.sales_order_detail_id = params[:sales_order_detail_id]
    new_object.order_type = params[:order_type]
    new_object.order_code = params[:order_code]
    new_object.amount = BigDecimal( params[:amount] || '0')
    new_object.pending_invoiced_amount = BigDecimal( params[:amount] || '0')
    if new_object.save
      new_object.code = "DOD-" + new_object.id.to_s  
      new_object.item_id = new_object.sales_order_detail.item_id
      new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    if self.delivery_order.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.delivery_order_id = params[:delivery_order_id]
    self.sales_order_detail_id = params[:sales_order_detail_id]
    self.amount = BigDecimal( params[:amount] || '0')
    self.pending_invoiced_amount = BigDecimal( params[:amount] || '0')
    if self.save
       self.item_id = self.sales_order_detail.item_id
    end
    return self
  end
  
  def delete_object
    if self.delivery_order.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.destroy
    return self
  end
end
