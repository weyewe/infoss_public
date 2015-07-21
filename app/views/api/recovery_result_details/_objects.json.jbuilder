
json.recovery_result_details  objects do |object|
    
    json.id 	object.id  
    json.item_id object.item_id
    json.item_sku object.item.sku
    json.item_name object.item.name 
    json.item_uom_name object.item.uom.name 
    json.amount object.amount 
end