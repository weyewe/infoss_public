json.purchase_invoices objects do |object|

	json.id 								object.id 
	json.invoice_date 			 format_date_friendly( object.invoice_date )   
	json.due_date 			 format_date_friendly( object.due_date )   
	json.description 			 object.description
	json.is_confirmed 			 object.is_confirmed
	
	json.purchase_receival_code 			object.purchase_receival.code 
	json.purchase_receival_id 				object.purchase_receival.id 
	
	json.purchase_receival_purchase_order_contact_name	object.purchase_receival.purchase_order.contact.name
	json.purchase_receival_purchase_order_exchange_name	object.purchase_receival.purchase_order.exchange.name
	json.exchange_rate_amount	object.exchange_rate_amount
	json.amount_payable	object.amount_payable
	
	json.confirmed_at 						format_date_friendly( 	object.confirmed_at ) 
	
	json.code 					 object.code
	json.nomor_surat 					 object.nomor_surat
 	
 	json.tax_value		object.purchase_receival.purchase_order.contact.is_taxable ? TAX_VALUE[ "code_#{object.purchase_receival.purchase_order.contact.tax_code}".to_sym ] : ""
 	
	
	
end
