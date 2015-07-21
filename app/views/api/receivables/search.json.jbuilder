
json.success true 
json.total @total
 

json.records @objects do |object|
    
    json.id 	object.id  
    json.source_class 	object.source_class  
    json.source_id 	object.source_id  
    json.source_code 	object.source_code  
    json.amount 	object.amount  
    json.remaining_amount 	object.remaining_amount  
    json.exchange_id 	object.exchange_id  
    json.exchange_name 	object.exchange.name 
    json.exchange_rate_amount 	object.exchange_rate_amount 
    json.contact_id 	object.contact_id 
    json.contact_name	object.contact.name 
    json.due_date 	object.due_date 
    json.pending_clearence_amount 	object.pending_clearence_amount 
    json.is_completed 	object.is_completed 
	
end
