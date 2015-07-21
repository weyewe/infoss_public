json.purchase_receivals objects do |object|

	json.id 								object.id 
	json.receival_date 			 format_date_friendly( object.receival_date )   
	json.is_confirmed 			 object.is_confirmed
	
	json.warehouse_name 			object.warehouse.name 
	json.warehouse_id 				object.warehouse.id 
	
	json.purchase_order_code 			object.purchase_order.code 
	json.purchase_order_id 				object.purchase_order.id 
	
	json.confirmed_at 						format_date_friendly( 	object.confirmed_at ) 
	
	json.code 					 object.code
 	json.nomor_surat 			 object.nomor_surat
	
	
end
