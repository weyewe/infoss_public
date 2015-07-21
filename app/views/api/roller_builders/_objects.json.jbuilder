json.roller_builders objects do |object|
  json.id   object.id  
  json.name		object.name  
  json.description 		object.description
  json.base_sku 		object.base_sku
  json.rd 		object.rd
  json.cd 		object.cd
  json.rl 		object.rl
  json.wl 		object.wl
  json.tl 		object.tl
  json.sku_roller_used_core 		object.sku_roller_used_core
  json.roller_used_core_item_id 		object.roller_used_core_item_id
  json.sku_roller_new_core 		object.sku_roller_new_core
  json.roller_new_core_item_id 		object.roller_new_core_item_id
  json.roller_used_core_item_amount 		object.roller_used_core_item.amount
  json.roller_new_core_item_amount 		object.roller_new_core_item.amount
  json.uom_id 		object.uom_id
  json.uom_name 		object.uom.name
  json.adhesive_id 		object.adhesive_id
  json.adhesive_name 		object.adhesive.name
  json.machine_id 		object.machine_id
  json.machine_name 		object.machine.name
  json.roller_type_id 		object.roller_type_id
  json.roller_type_name 		object.roller_type.name
  json.compound_id 		object.compound_id
  json.compound_name 		object.compound.name
  json.core_builder_id 		object.core_builder_id
  json.core_builder_sku 		object.core_builder.base_sku
  json.core_builder_name 		object.core_builder.name
  json.is_crowning 		object.is_crowning
  json.is_grooving 		object.is_grooving
  json.is_chamfer 		object.is_chamfer
  json.crowning_size 		object.crowning_size
  json.grooving_width 		object.grooving_width
  json.grooving_depth 		object.grooving_depth
  json.grooving_position 		object.grooving_position
  
end


