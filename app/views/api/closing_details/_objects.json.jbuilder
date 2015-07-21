json.closing_details objects do |object|
    json.closing_id 	object.closing_id 
    json.id 	object.id  
    json.exchange_id		object.exchange_id  
    json.exchange_name		object.exchange.name  
    json.rate		object.rate
end
