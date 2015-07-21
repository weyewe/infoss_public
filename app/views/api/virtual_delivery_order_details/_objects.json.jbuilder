json.virtual_delivery_order_details objects do |object|
    
    json.virtual_delivery_order_id object.virtual_delivery_order_id 
    
	json.id 								object.id  
	json.amount 						object.amount 
	json.code 			 object.code 
	
	json.virtual_order_detail_id                object.virtual_order_detail.id 
	json.virtual_order_detail_code 			 object.virtual_order_detail.code 
	json.virtual_order_detail_pending_delivery_amount 			 object.virtual_order_detail.pending_delivery_amount
	
	json.virtual_order_detail_item_id                object.virtual_order_detail.item.id 
	json.virtual_order_detail_item_sku 			 object.virtual_order_detail.item.sku 
	json.virtual_order_detail_item_name 			 object.virtual_order_detail.item.name
	
	json.virtual_order_detail_item_uom_id 			object.virtual_order_detail.item.uom.id 
	json.virtual_order_detail_item_uom_name 				object.virtual_order_detail.item.uom.name
	
 
	
	
end
