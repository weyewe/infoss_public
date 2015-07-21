class TemporaryDeliveryOrderDetail < ActiveRecord::Base
  
  belongs_to :temporary_delivery_order
  belongs_to :item
  belongs_to :sales_order_detail
  validate :valid_sales_order_detail
  
  def self.active_objects
    self
  end
  
  def valid_sales_order_detail
    return if  sales_order_detail_id.nil?
    pod = SalesOrderDetail.find_by_id sales_order_detail_id
    if pod.nil? 
      self.errors.add(:item_id, "Harus ada sales_order_detail_id")
      return self 
    end
    
    itemcount = TemporaryDeliveryOrderDetail.where(
      :sales_order_detail_id => sales_order_detail_id,
      :temporary_delivery_order_id => temporary_delivery_order_id,
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
    temporary_delivery_order = TemporaryDeliveryOrder.find_by_id(params[:temporary_delivery_order_id])
    if not temporary_delivery_order.nil?
      if temporary_delivery_order.is_confirmed?
        new_object.errors.add(:generic_errors, "Sudah di konfirmasi")
        return new_object 
      end
    end
    new_object.temporary_delivery_order_id = params[:temporary_delivery_order_id]
    new_object.sales_order_detail_id = params[:sales_order_detail_id]
    new_object.amount = params[:amount]
    if new_object.save  
    new_object.code = "TDOD-" + new_object.id.to_s  
    new_object.item_id = new_object.sales_order_detail.item_id
    new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    if self.temporary_delivery_order.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.temporary_delivery_order_id = params[:temporary_delivery_order_id]
    self.sales_order_detail_id = params[:sales_order_detail_id]
    self.amount = params[:amount]
    if self.save
      self.item_id = self.sales_order_detail.item_id
    end
    return self
  end
  
  def delete_object
    if self.temporary_delivery_order.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.destroy
    return self
  end
  
  
end
