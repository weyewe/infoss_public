json.virtual_orders objects do |object|

	json.id 								object.id 
	json.order_date 			 format_date_friendly( object.order_date )   
	json.order_type 			 object.order_type 
	
	if object.order_type == 0
		json.order_type_text  "Trial Order"
	elsif object.order_type == 1
		json.order_type_text  "Sample Order"
	else
		json.order_type_text  "Consignment"
	end
	
	json.is_confirmed 			 object.is_confirmed
	
	json.contact_name 			object.contact.name 
	json.contact_id 				object.contact.id 
	
	json.employee_name 			object.employee.name 
	json.employee_id 				object.employee.id 
	
	json.exchange_name 			object.exchange.name 
	json.exchange_id 				object.exchange.id 
	
	json.confirmed_at 						format_date_friendly( 	object.confirmed_at ) 
	
	json.code 					 object.code
 	json.nomor_surat 					 object.nomor_surat
	
	
end
