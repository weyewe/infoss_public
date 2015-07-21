
json.batch_sources objects do |object|
	json.id 		object.id 
	json.item_id		object.item_id 
	json.item_sku  object.item.sku
	json.item_name object.item.name 
	json.source_class		object.source_class
	json.source_id		object.source_id 
	
	
	json.amount		object.amount
	json.unallocated_amount		object.unallocated_amount 
	json.generated_date		format_date_friendly( object.generated_date ) 
	
	json.status     object.status 
	if object.status  == ADJUSTMENT_STATUS[:addition]
	    json.status_text "Penambahan"
	else
	    json.status_text "Pengurangan"
	end
end