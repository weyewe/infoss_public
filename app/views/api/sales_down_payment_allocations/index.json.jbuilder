
json.success true 
json.total @total
 

json.sales_down_payment_allocations @objects do |object|
    
    
	json.id		object.id  
	json.contact_id		object.contact_id  
	json.contact_name		object.contact.name  
	json.payable_id		object.payable_id
	json.payable_source_code		object.payable.source_code
	json.code		object.code
	json.allocation_date	format_date_friendly( 	object.allocation_date ) 
	json.total_amount		object.total_amount
	json.rate_to_idr		object.rate_to_idr
	json.is_confirmed		object.is_confirmed
	json.confirmed_at 	format_date_friendly( 	object.confirmed_at ) 
	
end
