
json.delivery_orders objects do |object|

	json.id 								object.id 
	json.delivery_date 			 format_date_friendly( object.delivery_date )   
	json.is_confirmed 			 object.is_confirmed
	
	json.warehouse_name 			object.warehouse.name 
	json.warehouse_id 				object.warehouse.id 
	
	json.sales_order_code 			object.sales_order.code 
	json.sales_order_id 				object.sales_order.id 
	json.sales_order_nomor_surat 				object.sales_order.nomor_surat
	
	json.confirmed_at 						format_date_friendly( 	object.confirmed_at ) 
	
	json.code 					 object.code
 	json.nomor_surat 			 object.nomor_surat
	
	
end
