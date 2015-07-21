json.stock_adjustments objects do |object|

	json.id 								object.id 
	json.adjustment_date 			 format_date_friendly( object.adjustment_date )   
	json.description 			 object.description
	json.is_confirmed 			 object.is_confirmed
	
	json.warehouse_name 			object.warehouse.name 
	json.warehouse_id 				object.warehouse.id 
	
	json.confirmed_at 						format_date_friendly( 	object.confirmed_at ) 
	
	json.code 					 object.code
 
	
	
end
