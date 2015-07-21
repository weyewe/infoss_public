json.purchase_invoice_details objects do |object|
    
    json.purchase_invoice_id object.purchase_invoice_id 
    
	json.id 								object.id  
	json.amount 						object.amount 
	json.price 					 object.amount * object.purchase_receival_detail.purchase_order_detail.price
	json.code 			 object.code 
	
	json.purchase_receival_detail_id                object.purchase_receival_detail.id 
	json.purchase_receival_detail_code 			 object.purchase_receival_detail.code 
	
	json.purchase_receival_detail_purchase_order_detail_price	 object.purchase_receival_detail.purchase_order_detail.price
	
	json.purchase_receival_detail_purchase_order_detail_item_id                object.purchase_receival_detail.item.id 
	json.purchase_receival_detail_purchase_order_detail_item_sku 			 object.purchase_receival_detail.item.sku 
	json.purchase_receival_detail_purchase_order_detail_item_name 			 object.purchase_receival_detail.item.name
	
	json.purchase_receival_detail_purchase_order_detail_item_uom_id 			object.purchase_receival_detail.item.uom.id 
	json.purchase_receival_detail_purchase_order_detail_item_uom_name 				object.purchase_receival_detail.item.uom.name
	
 
	
	
end
