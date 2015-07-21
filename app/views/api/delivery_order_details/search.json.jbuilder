	
json.success true 
json.total @total
 

json.records @objects do |object|
    
    json.delivery_order_id object.delivery_order_id 
    
	json.id 								object.id  
	json.amount 						object.amount 
	json.sales_order_detail_pending_delivery_amount 						object.sales_order_detail.pending_delivery_amount 
	json.sales_order_detail_price 					 object.sales_order_detail.price
	json.code 			 object.code 
	
	json.sales_order_detail_item_id                object.sales_order_detail.item.id 
	json.sales_order_detail_item_sku 			 object.sales_order_detail.item.sku 
	json.sales_order_detail_item_name 			 object.sales_order_detail.item.name
	
	json.sales_order_detail_item_uom_id 			object.sales_order_detail.item.uom.id 
	json.sales_order_detail_item_uom_name 				object.sales_order_detail.item.uom.name
	
	json.sales_order_detail_is_service  object.sales_order_detail.is_service
	if object.sales_order_detail.is_service == true
		json.sales_order_detail_is_service_text  "Service"
	else
		json.sales_order_detail_is_service_text  "Trading"
	end
 
	
	
end
