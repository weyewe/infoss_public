json.payment_vouchers objects do |object|

	json.id 								object.id 
  json.payment_date 			 format_date_friendly( object.payment_date )   
	json.no_bukti 			 object.no_bukti
  json.contact_id 			 object.contact_id
  json.contact_name 			 object.contact.name
  json.cash_bank_id 			 object.cash_bank_id
  json.cash_bank_name 			 object.cash_bank.name
  json.cash_bank_exchange_name 			 object.cash_bank.exchange.name
	json.is_confirmed 			 object.is_confirmed
	json.gbch_no 			 object.gbch_no
	json.is_gbch 			 object.is_gbch
	json.due_date 			 format_date_friendly(  object.due_date ) 
	
	json.confirmed_at 						format_date_friendly( 	object.confirmed_at ) 
	
	json.code 					 object.code
	json.amount 					 object.amount
	json.rate_to_idr 					 object.rate_to_idr
	json.biaya_bank 					 object.biaya_bank
	json.pembulatan 					 object.pembulatan
	json.total_pph_23 					 object.total_pph_23
	json.total_pph_21 					 object.total_pph_21
	json.status_pembulatan 					 object.status_pembulatan
	if object.status_pembulatan == 1
		json.status_pembulatan_text  "Debet"
	else
		json.status_pembulatan_text  "Credit"
	end
	
	
end
