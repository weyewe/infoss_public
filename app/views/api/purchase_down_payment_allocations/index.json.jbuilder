
json.success true 
json.total @total
 

json.purchase_down_payment_allocations @objects do |object|
    
    
	json.id		object.id  
	json.contact_id		object.contact_id  
	json.contact_name		object.contact.name  
	json.receivable_id		object.receivable_id
	json.receivable_source_code		object.receivable.source_code
	json.code		object.code
	json.allocation_date	format_date_friendly( 	object.allocation_date ) 
	json.total_amount		object.total_amount
	json.rate_to_idr		object.rate_to_idr
	json.is_confirmed		object.is_confirmed
	json.confirmed_at 	format_date_friendly( 	object.confirmed_at ) 
	
end
