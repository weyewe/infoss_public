json.warehouse_mutations objects do |object|

	json.id 								object.id 
	json.mutation_date 			 format_date_friendly( object.mutation_date )   
	json.is_confirmed 			 object.is_confirmed
	
	json.warehouse_from_name 			object.warehouse_from.name 
	json.warehouse_from_id 				object.warehouse_from.id 
	
	json.warehouse_to_name 			object.warehouse_to.name 
	json.warehouse_to_id 				object.warehouse_to.id 
	
	json.confirmed_at 						format_date_friendly( 	object.confirmed_at ) 
	
	json.code 					 object.code
 
	
	
end
