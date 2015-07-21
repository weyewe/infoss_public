json.virtual_order_clearances objects do |object|

	json.id 	object.id 
	json.code 	object.code 
	json.virtual_delivery_order_id 		object.virtual_delivery_order_id 
	json.virtual_delivery_order_code 		object.virtual_delivery_order.code
	json.clearance_date 		format_date_friendly( object.clearance_date )
	json.total_waste_cogs 		object.total_waste_cogs 
	json.is_waste 		object.is_waste 
	json.is_confirmed 			 object.is_confirmed
	json.confirmed_at 						format_date_friendly( 	object.confirmed_at ) 
	
	
end
