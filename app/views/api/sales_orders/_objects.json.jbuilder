json.sales_orders objects do |object|

	json.id 								object.id 
	json.sales_date 			 format_date_friendly( object.sales_date )   
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