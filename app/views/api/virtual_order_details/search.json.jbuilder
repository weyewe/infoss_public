
json.success true 
json.total @total
 

json.records @objects do |object|
    
     json.virtual_order_id object.virtual_order_id 
    
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
 
	
	
end
