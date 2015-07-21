
json.success true 
json.total @total
 

json.bank_administrations @objects do |object|
	json.id 		object.id 
	json.cash_bank_id 		object.cash_bank_id 
	json.cash_bank_name 		object.cash_bank.name 
	json.administration_date 		object.administration_date 
	json.code 		object.code 
	json.no_bukti 		object.no_bukti 
	json.amount 		object.amount 
	json.exchange_rate_amount 		object.exchange_rate_amount 
	json.exchange_rate_id 		object.exchange_rate_id 
	json.description 		object.description 
	json.is_confirmed 		object.is_confirmed 
	json.confirmed_at 		object.confirmed_at 
end
