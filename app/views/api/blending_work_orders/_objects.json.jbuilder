
json.blending_work_orders objects do |object|

	json.id 	object.id 
	json.code 	object.code 
	json.description 	object.description 
	json.blending_recipe_id 	object.blending_recipe_id 
	json.blending_recipe_name 	object.blending_recipe.name 
	json.blending_recipe_target_item_sku 	object.blending_recipe.target_item.sku 
	json.blending_recipe_target_item_name 	object.blending_recipe.target_item.name 
	json.blending_recipe_target_item_uom_name 	object.blending_recipe.target_item.uom.name 
	json.blending_recipe_target_amount 	object.blending_recipe.target_amount 
	json.blending_date  format_date_friendly( object.blending_date )
	json.warehouse_id  object.warehouse_id
	json.warehouse_name  object.warehouse.name
	json.confirmed_at  		format_date_friendly( object.confirmed_at )  
  json.is_confirmed   object.is_confirmed  

end
