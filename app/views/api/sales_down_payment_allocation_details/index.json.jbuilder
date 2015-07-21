
json.success true 
json.total @total
 

json.sales_down_payment_allocation_details @objects do |object|
    
    json.sales_down_payment_allocation_id 	object.sales_down_payment_allocation_id 
	json.id 	object.id  
	json.receivable_id 	object.receivable_id  
	json.receivable_source_code 	object.receivable.source_code  
	json.code 	object.code  
	json.amount 	object.amount  
	json.amount_paid 	object.amount_paid  
	json.rate 	object.rate  
	json.description 	object.description  
	
end