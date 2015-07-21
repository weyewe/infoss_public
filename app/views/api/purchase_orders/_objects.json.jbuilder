json.purchase_orders objects do |object|

	json.id 								object.id 
	json.purchase_date 			 format_date_friendly( object.purchase_date )   
	json.is_confirmed 			 object.is_confirmed
	
	json.contact_name 			object.contact.name 
	json.contact_id 				object.contact.id 
	
	json.exchange_name 			object.exchange.name 
	json.exchange_id 				object.exchange.id 
	
	json.confirmed_at 						format_date_friendly( 	object.confirmed_at ) 
	
	json.code 					 object.code
 	json.nomor_surat 					 object.nomor_surat
	
	json.allow_edit_detail  object.allow_edit_detail
	if object.allow_edit_detail == true
		json.allow_edit_detail_text  "Yes"
	else
		json.allow_edit_detail_text  "No"
	end
	
end
