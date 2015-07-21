json.virtual_order_clearance_details objects do |object|
    
    json.virtual_order_clearance_id object.virtual_order_clearance_id 
    json.code object.code 
	json.id  object.id 
	json.virtual_delivery_order_detail_id 	object.virtual_delivery_order_detail_id 
	json.virtual_delivery_order_detail_item_name 	object.virtual_delivery_order_detail.item.name
	json.virtual_delivery_order_detail_item_sku	object.virtual_delivery_order_detail.item.sku
	json.amount	object.amount
	json.waste_cogs	object.waste_cogs
	json.selling_price	object.selling_price
	
end
