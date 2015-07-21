
json.cash_banks objects do |object|
  
	json.id 								object.id  			
  json.name							object.name
  json.description 						object.description 
	json.amount						object.amount
	json.is_bank					object.is_bank
	
	json.exchange_id object.exchange_id
	json.exchange_name object.exchange.name 
	 
end