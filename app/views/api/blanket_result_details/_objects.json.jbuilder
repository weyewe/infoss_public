
json.blanket_result_details objects do |object|
    
	json.id 								object.id  
	json.blanket_order_detail_id                object.blanket_order_detail_id 
	
	json.finish_amount                object.finish_amount 
	json.defect_amount                object.defect_amount 
	json.reject_amount                object.reject_amount 
	
	json.batch_instance_id              object.batch_instance_id 
	json.batch_instance_name                 object.batch_instance.name
	  
end
