json.closings objects do |object|
	json.id 								object.id  
	json.period 					object.period
	json.year_period 					object.year_period
	json.beginning_period 		format_date_friendly( object.beginning_period ) 
	json.end_date_period 		format_date_friendly( object.end_date_period ) 
	json.is_year_closing 		object.is_year_closing
	json.closed_at  		format_date_friendly( object.closed_at )  
	json.is_closed   object.is_closed
end
