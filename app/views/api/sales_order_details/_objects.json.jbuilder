json.sales_order_details objects do |object|
    
    json.sales_order_id object.sales_order_id 
    
	json.id 								object.id  
	json.amount 						object.amount 
	json.pending_delivery_amount 						object.pending_delivery_amount 
	json.price 					 object.price
	json.code 			 object.code 
	
	json.item_id                object.item.id 
	json.item_sku 			 object.item.sku 
	json.item_name 			 object.item.name
	
	json.item_uom_id 			object.item.uom.id 
	json.item_uom_name 				object.item.uom.name
	
	json.is_service  object.is_service
	if object.is_service == true
		json.is_service_text  "Service"
	else
		json.is_service_text  "Trading"
	end
 
	
	
end
