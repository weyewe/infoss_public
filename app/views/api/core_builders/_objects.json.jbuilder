
json.core_builders objects do |object| 
	json.id object.id  
	 
	json.name	object.name
	json.description	object.description
	json.base_sku object.base_sku
	json.sku_new_core	object.sku_new_core
	json.sku_used_core	object.sku_used_core
	json.used_core_item_id	object.used_core_item_id
	json.new_core_item_id	object.new_core_item_id
	json.used_core_item_amount  object.used_core_item.amount
	json.new_core_item_amount   object.new_core_item.amount
	
	json.uom_id	object.uom_id
	json.machine_id	object.machine_id
	json.core_builder_type_case	object.core_builder_type_case
	json.cd	object.cd
	json.tl	object.tl
	
	json.uom_name object.uom.name
	json.machine_name object.machine.name
	
end