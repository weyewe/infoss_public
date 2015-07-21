json.sales_invoices objects do |object|

	json.id 								object.id 
	json.invoice_date 			 format_date_friendly( object.invoice_date )   
	json.due_date 			 format_date_friendly( object.due_date )   
	json.description 			 object.description
	json.is_confirmed 			 object.is_confirmed
	
	json.delivery_order_code 			object.delivery_order.code 
	json.delivery_order_id 				object.delivery_order.id 
	
	json.delivery_order_sales_order_contact_name	object.delivery_order.sales_order.contact.name
	json.delivery_order_sales_order_exchange_name	object.delivery_order.sales_order.exchange.name
	json.exchange_rate_amount	object.exchange_rate_amount
	json.amount_receivable	object.amount_receivable
	json.total_cos	object.total_cos
	
	json.confirmed_at 						format_date_friendly( 	object.confirmed_at ) 
	
	json.code 					 object.code
	json.nomor_surat 					 object.nomor_surat
 	
 	json.tax_value		object.delivery_order.sales_order.contact.is_taxable ? TAX_VALUE[ "code_#{object.delivery_order.sales_order.contact.tax_code}".to_sym ] : ""
 	
	
	
end
