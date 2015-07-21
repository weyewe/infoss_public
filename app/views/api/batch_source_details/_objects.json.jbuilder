
json.batch_source_details objects do |object|
	json.id 		object.id 
	json.batch_instance_id		object.batch_instance_id 
	json.batch_instance_name    object.batch_instance.name
	json.batch_source_id  object.batch_source_id
	
	json.amount object.amount
	json.status		object.status 
	
	json.batch_instance_total_allocated_amount object.batch_instance.total_allocated_amount
	json.batch_instance_amount  object.batch_instance.amount
	
	if object.status == ADJUSTMENT_STATUS[:deduction]
	    json.status_text "Pengurangan"
	else
	    json.status_text "Penambahan"  
	end
	
 
end