json.payment_voucher_details objects do |object| 

	json.id 								object.id 
    json.payment_voucher_id 		  object.payment_voucher_id  
    json.payable_id 			 object.payable_id
    json.payable_source_code			 object.payable.source_code
    json.payable_amount			 object.payable.amount
    json.payable_remaining_amount			 object.payable.remaining_amount
    json.payable_exchange_name			 object.payable.exchange.name
    json.payable_exchange_rate_amount			 object.payable.exchange_rate_amount
    json.payable_due_date			 object.payable.due_date
    json.payable_pending_clearence_amount			 object.payable.pending_clearence_amount
    json.amount 						object.amount 
    json.amount_paid 						object.amount_paid 
    json.pph_21 						object.pph_21 
    json.pph_23 						object.pph_23 
    json.rate 						object.rate 
    json.description 						object.description 
	
end
