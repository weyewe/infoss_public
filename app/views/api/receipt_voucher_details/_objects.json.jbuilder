json.receipt_voucher_details objects do |object| 

	json.id 								object.id 
    json.receipt_voucher_id 		  object.receipt_voucher_id  
    json.receivable_id 			 object.receivable_id
    json.receivable_source_code			 object.receivable.source_code
    json.receivable_amount			 object.receivable.amount
    json.receivable_remaining_amount			 object.receivable.remaining_amount
    json.receivable_exchange_name			 object.receivable.exchange.name
    json.receivable_exchange_rate_amount			 object.receivable.exchange_rate_amount
    json.receivable_due_date			 object.receivable.due_date
    json.receivable_pending_clearence_amount			 object.receivable.pending_clearence_amount
    json.amount 						object.amount 
    json.amount_paid 						object.amount_paid 
    json.pph_23 						object.pph_23 
    json.rate 						object.rate 
    json.description 						object.description 
	
end
