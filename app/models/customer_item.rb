class CustomerItem < ActiveRecord::Base
    
  belongs_to :contact
  belongs_to :warehouse_item
  
  def self.active_objects
    self
  end
  
  def self.create_object(params)
    new_object = self.new 
    new_object.contact_id = params[:contact_id]
    new_object.customer_item_id = params[:customer_item_id]
    new_object.amount = BigDecimal( params[:amount] || '0')
    new_object.virtual = BigDecimal( params[:virtual] || '0')
    new_object.save 
    return self 
  end
   
  def self.find_or_create_object(params)
    item_in_customer = CustomerItem.where(
      :contact_id => params[:contact_id],
      :warehouse_item_id =>params[:warehouse_item_id]).first
    if item_in_customer.nil?
      item_in_customer = self.new 
      item_in_customer.contact_id = params[:contact_id]
      item_in_customer.warehouse_item_id = params[:warehouse_item_id]
      item_in_customer.save 
    end
    return item_in_customer
  end
  
  def update_amount(amount)
    self.amount += amount
    self.save
  end
  
  def update_virtual(amount)
    self.virtual += amount
    self.save
  end
  
  def delete_object
    self.destroy
    return self
  end
  
end
