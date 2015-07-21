json.memorials objects do |object|
	json.id 								object.id  
	json.code 					object.code
	json.no_bukti 					object.no_bukti
	json.description 		object.description
	json.amount 		object.amount
  json.confirmed_at  		format_date_friendly( object.confirmed_at )  
  json.is_confirmed   object.is_confirmed  
end


