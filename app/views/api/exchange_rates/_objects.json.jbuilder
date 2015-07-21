json.exchange_rates objects do |object|
	json.id 								object.id 
    json.exchange_name      object.exchange.name
    json.exchange_id object.exchange_id
	
	json.ex_rate_date 	format_date_friendly( object.ex_rate_date )  
	json.rate       object.rate 
  
end

  