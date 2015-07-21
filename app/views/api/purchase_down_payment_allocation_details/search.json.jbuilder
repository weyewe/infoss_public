
json.success true 
json.total @total
 

json.records @objects do |object|
    
    json.purchase_down_payment_allocation_id 	object.purchase_down_payment_allocation_id 
	json.id 	object.id  
	json.payable_id 	object.payable_id  
	json.payable_source_code 	object.payable.source_code  
	json.code 	object.code  
	json.amount 	object.amount  
	json.amount_paid 	object.amount_paid  
	json.rate 	object.rate  
	json.description 	object.description  
 
end
