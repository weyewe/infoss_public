json.purchase_receival_details objects do |object|
    
    json.purchase_receival_id object.purchase_receival_id 
    
	json.id 								object.id  
	json.amount 						object.amount 
	json.code 			 object.code 
	
	json.purchase_order_detail_id                object.purchase_order_detail.id 
	json.purchase_order_detail_code 			 object.purchase_order_detail.code 
	json.purchase_order_detail_pending_receival_amount 			 object.purchase_order_detail.pending_receival_amount
	
	json.purchase_order_detail_item_id                object.purchase_order_detail.item.id 
	json.purchase_order_detail_item_sku 			 object.purchase_order_detail.item.sku 
	json.purchase_order_detail_item_name 			 object.purchase_order_detail.item.name
	
	json.purchase_order_detail_item_uom_id 			object.purchase_order_detail.item.uom.id 
	json.purchase_order_detail_item_uom_name 				object.purchase_order_detail.item.uom.name
	
 
	
	
end
