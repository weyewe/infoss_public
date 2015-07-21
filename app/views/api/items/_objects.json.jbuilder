json.items objects do |object|
	json.id 								object.id  
	json.sku			object.sku 
	json.name   object.name
	
	json.description object.description 
	json.is_tradeable object.is_tradeable
	json.minimum_amount object.minimum_amount
	json.selling_price object.selling_price
	
	json.price_list object.price_list  
    	
    	
	json.exchange_id object.exchange_id
	json.exchange_name object.exchange.name 
	
	
	json.item_type_id object.item_type_id
	json.item_type_name object.item_type.name 	
	
	json.sub_type_id object.sub_type_id
	if object.sub_type_id.nil?
		json.sub_type_name  ''
	else
		json.sub_type_name object.sub_type.name 
	end
	
	json.uom_id object.uom_id
	json.uom_name object.uom.name 

  
	  


	
end


