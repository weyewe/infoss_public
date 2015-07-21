json.blending_recipes objects do |object|

	json.id 								object.id 
	json.name 			 object.name
	json.description 			 object.description
	json.target_item_id 			 object.target_item_id
	json.target_item_sku			 object.target_item.sku
	
	json.target_item_name 			object.target_item.name 
	json.target_item_uom_name 			object.target_item.uom.name 
	json.target_amount 				object.target_amount
end
