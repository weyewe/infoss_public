
json.success true 
json.total @total
 

json.records @objects do |object|
    
	json.id 	object.id  
	json.bank_administration_id		object.bank_administration_id  
	json.account_id		object.account_id  
	json.account_code		object.account.code  
	json.account_name		object.account.name  
	json.code		object.code  
	json.description		object.description  
	json.status		object.status  
	if object.status == 1 
		json.status_text	"Debet"
	else
		json.status_text	"Credit"
	end
	json.amount		object.amount  
	json.is_legacy		object.is_legacy  
	
end
