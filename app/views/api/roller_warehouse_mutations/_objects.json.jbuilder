json.roller_warehouse_mutations objects do |object|
    
	json.id		object.id  
	json.recovery_order_id		object.recovery_order_id  
	json.recovery_order_code		object.recovery_order.code  
	json.code		object.code  
	json.warehouse_from_id		object.warehouse_from_id  
	json.warehouse_from_name		object.warehouse_from.name  
	json.warehouse_to_id		object.warehouse_to_id  
	json.warehouse_to_name		object.warehouse_to.name  
	json.is_confirmed		object.is_confirmed 
	json.amount		object.amount 
	json.confirmed_at		format_date_friendly( object.confirmed_at )       
	json.mutation_date	format_date_friendly( object.mutation_date ) 
end


