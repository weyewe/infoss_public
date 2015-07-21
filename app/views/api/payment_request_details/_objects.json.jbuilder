json.payment_request_details objects do |object|
    
    json.payment_request_id 	object.payment_request_id 
    json.id 	object.id  
    json.status		object.status  
    if object.status == 1
		json.status_text  "Debet"
	else
		json.status_text  "Credit"
	end
    json.amount		object.amount  
    json.code		object.code  
    json.account_id		object.account_id  
    json.account_name		object.account.name 
    json.account_code		object.account.code 
	
end
