
json.success true 
json.total @total
 

json.records @objects do |object|
    json.id 	object.id    
    json.roller_identification_form_detail_id 	object.roller_identification_form_detail_id    
    json.item_id 	object.item_id    
    json.item_sku 	object.item.sku    
    json.item_name 	object.item.name    
    json.amount 	object.amount    
end
