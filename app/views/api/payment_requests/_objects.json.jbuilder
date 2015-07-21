json.payment_requests objects do |object|
	json.id 								object.id  
  json.contact_name		object.contact.name  
  json.contact_id		  object.contact_id  
	json.code 					object.code
	json.no_bukti 					object.no_bukti
	json.description 		object.description
	json.amount 		object.amount
	json.account_id 		object.account_id
  json.request_date  		format_date_friendly( object.request_date )
  json.due_date  		format_date_friendly( object.due_date )
  json.confirmed_at  		format_date_friendly( object.confirmed_at )  
  json.is_confirmed   object.is_confirmed  
end


