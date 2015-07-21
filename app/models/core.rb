class Core < ActiveRecord::Base
 acts_as :item
 
 def self.create_object(params)
  new_object = self.new
  new_object.item_type_id = ItemType.find_by_name("Core").id
  new_object.sku = params[:sku]
  new_object.name = params[:name]
  new_object.description = params[:description]
  new_object.is_tradeable = false
  new_object.uom_id = params[:uom_id]
  new_object.minimum_amount = BigDecimal('1')  
  new_object.selling_price = BigDecimal('1')  
  new_object.price_list = BigDecimal('1')  
  new_object.exchange_id = Exchange.where(:is_base => true).first.id
  new_object.save
  return new_object
 end
 
 def update_object(params)
   self.name = params[:name]
   self.description = params[:description]
   self.save
   return self
 end
 
 def delete_object
   self.destroy
   return self
 end
 
end
