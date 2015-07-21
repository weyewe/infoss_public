
json.blanket_orders objects do |object|
	json.id 		object.id 
	json.contact_id		object.contact_id 
	json.contact_name		object.contact.name 
	json.warehouse_id		object.warehouse_id 
	json.warehouse_name		object.warehouse.name 
	json.code		object.code 
	json.amount_received		object.amount_received 
	json.amount_rejected		object.amount_rejected 
	json.amount_final		object.amount_final 
	json.production_no		object.production_no 
	json.order_date			format_date_friendly( object.order_date ) 
	json.notes		object.notes 
	json.is_confirmed		object.is_confirmed 
	json.is_completed		object.is_completed 
	json.has_due_date		object.has_due_date 
	json.confirmed_at		format_date_friendly( object.confirmed_at ) 
	json.due_date	format_date_friendly( object.due_date ) 
end