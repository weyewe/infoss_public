
json.batch_instances @objects do |object|
	json.id 								object.id 
	json.name       object.name
	json.description object.description 
	
	json.manufactured_at   format_date_friendly( object.manufactured_at ) 
	json.amount object.amount 
	
	json.item_id object.item_id 
	json.item_sku object.item.sku
	json.item_name object.item.name
	
	
	json.item_type_id            object.item_type.id 
	json.item_type_name         object.item_type.name 
	json.total_allocated_amount object.amount
	  

	
	
end
