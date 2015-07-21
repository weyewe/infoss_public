class WarehouseItem < ActiveRecord::Base

  belongs_to :warehouse
  belongs_to :item 
  
  def self.active_objects
    self
  end
  
  def self.create_object(params)
    new_object = self.new 
    new_object.warehouse_id = params[:warehouse_id]
    new_object.item_id = params[:item_id]
    new_object.amount = BigDecimal( params[:amount] || '0')
    new_object.customer_amount = BigDecimal( params[:customer_amount] || '0')
    new_object.save 
    return self 
  end
   
  def self.find_or_create_object(params)
    item_in_warehouse = WarehouseItem.where(:warehouse_id => params[:warehouse_id],:item_id =>params[:item_id]).first
    if item_in_warehouse.nil?
      item_in_warehouse = self.new 
      item_in_warehouse.warehouse_id = params[:warehouse_id]
      item_in_warehouse.item_id = params[:item_id]
      item_in_warehouse.save 
    end
    return item_in_warehouse
  end
  
  def update_amount(amount)
    self.amount += amount
    self.save
  end
  
  def update_pending_receival(amount)
    self.pending_receival += amount
    self.save
  end
  
  def update_pending_delivery(amount)
    self.pending_delivery += amount
    self.save
  end
  
  def update_customer_amount(amount)
    self.customer_amount += amount
    self.save
  end
  
  def delete_object
    self.destroy
    return self
  end
  
end
