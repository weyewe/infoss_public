json.temporary_delivery_orders objects do |object|

	json.id 								object.id 
	json.code 								object.code 
	json.delivery_order_id 								object.delivery_order_id 
	json.delivery_order_code 								object.delivery_order.code 
	json.delivery_order_nomor_surat 								object.delivery_order.nomor_surat 
	json.delivery_date 			 format_date_friendly( object.delivery_date )   
	json.contact_name 			 	object.delivery_order.sales_order.contact.name   
	json.warehouse_id 								object.warehouse_id 
	json.warehouse_name 								object.warehouse.name 
	json.nomor_surat 								object.nomor_surat 
	json.total_waste_cogs 			 object.total_waste_cogs
	json.is_delivery_completed 			 object.is_delivery_completed
	json.is_reconciled 			 object.is_reconciled
	json.is_pushed 			 object.is_pushed
	json.push_date 			 format_date_friendly( object.push_date )   
	json.confirmed_at 						format_date_friendly( 	object.confirmed_at ) 
	
end
