json.sales_invoice_details objects do |object|
    
    json.sales_invoice_id object.sales_invoice_id 
    
	json.id 								object.id  
	json.amount 						object.amount 
	json.price 					 object.amount * object.delivery_order_detail.sales_order_detail.price
	json.code 			 object.code 
	
	json.delivery_order_detail_id                object.delivery_order_detail.id 
	json.delivery_order_detail_code 			 object.delivery_order_detail.code 
	
	json.delivery_order_detail_sales_order_detail_is_service	object.delivery_order_detail.sales_order_detail.is_service
	json.delivery_order_detail_sales_order_detail_price	 object.delivery_order_detail.sales_order_detail.price
	
	json.delivery_order_detail_sales_order_detail_item_id                object.delivery_order_detail.item.id 
	json.delivery_order_detail_sales_order_detail_item_sku 			 object.delivery_order_detail.item.sku 
	json.delivery_order_detail_sales_order_detail_item_name 			 object.delivery_order_detail.item.name
	
	json.delivery_order_detail_sales_order_detail_item_uom_id 			object.delivery_order_detail.item.uom.id 
	json.delivery_order_detail_sales_order_detail_item_uom_name 				object.delivery_order_detail.item.uom.name
	
 
	
	
end
