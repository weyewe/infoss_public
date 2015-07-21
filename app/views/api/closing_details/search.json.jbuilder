
json.success true 
json.total @total
 

json.records @objects do |object|
    
   json.memorial_id 	object.memorial_id 
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
 
	
	
end
