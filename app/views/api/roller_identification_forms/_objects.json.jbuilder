json.roller_identification_forms  objects do |object|
	json.id     object.id  
	json.code     object.code  
	json.warehouse_id     object.warehouse_id  
	json.warehouse_name     object.warehouse.name  
	json.nomor_disasembly     object.nomor_disasembly  
	json.incoming_roll     format_date_friendly( object.incoming_roll )
	json.contact_id     object.contact_id  
	json.contact_name     object.contact.name  
	json.is_in_house     object.is_in_house  
	json.amount     object.amount  
	json.identified_date    format_date_friendly( object.identified_date )
	json.is_confirmed     object.is_confirmed  
	json.is_completed     object.is_completed  
	json.confirmed_at     format_date_friendly( object.confirmed_at )
end


