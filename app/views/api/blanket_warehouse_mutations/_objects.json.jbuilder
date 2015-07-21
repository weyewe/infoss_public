json.blanket_warehouse_mutations objects do |object|
	json.id		object.id  
	json.blanket_order_id		object.blanket_order_id  
	json.blanket_order_production_no		object.blanket_order.production_no  
	json.code		object.code  
	json.warehouse_from_id		object.warehouse_from_id  
	json.warehouse_from_name		object.warehouse_from.name  
	json.warehouse_to_id		object.warehouse_to_id  
	json.warehouse_to_name		object.warehouse_to.name  
	json.is_confirmed		object.is_confirmed 
	json.confirmed_at		format_date_friendly( object.confirmed_at )       
	json.mutation_date	format_date_friendly( object.mutation_date ) 
end