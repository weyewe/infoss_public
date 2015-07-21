
json.success true 
json.total @total
 

json.records @objects do |object|
    
  json.id 	object.id  
    json.recovery_order_id 	object.recovery_order_id  
    json.roller_identification_form_detail_id 	object.roller_identification_form_detail_id  
    json.roller_identification_form_detail_core_sku 	object.roller_identification_form_detail.core_builder.base_sku  
    json.roller_identification_form_detail_core_name 	object.roller_identification_form_detail.core_builder.name
    json.roller_builder_id 	object.roller_builder_id
    json.roller_builder_sku 	object.roller_builder.base_sku
    json.roller_builder_name 	object.roller_builder.name
    json.total_cost 	object.total_cost
    json.compound_usage 	object.compound_usage
    json.core_type_case 	object.core_type_case
    json.core_type_case_text 	object.core_type_case
    json.is_disassembled 	object.is_disassembled
    json.is_stripped_and_glued 	object.is_stripped_and_glued
    json.is_wrapped 	object.is_wrapped
    json.is_vulcanized 	object.is_vulcanized
    json.is_faced_off 	object.is_faced_off
    json.is_conventional_grinded 	object.is_conventional_grinded
    json.is_cnc_grinded 	object.is_cnc_grinded
    json.is_polished_and_gc 	object.is_polished_and_gc
    json.is_packaged 	object.is_packaged
    json.is_rejected 	object.is_rejected
    json.rejected_date 	format_date_friendly( object.rejected_date )  
    json.is_finished 	object.is_finished
    json.finished_date 	format_date_friendly( object.finished_date )  
    json.accessories_cost 	object.accessories_cost
    json.core_cost 	object.core_cost
    json.compound_cost 	object.compound_cost
    json.compound_under_layer_id 	object.compound_under_layer_id
    if object.compound_under_layer_id == 0 ||  object.compound_under_layer_id.nil? 
      json.compound_under_layer_name ""
    else
      json.compound_under_layer_name 	object.compound_under_layer.name
    end
    json.compound_under_layer_usage 	object.compound_under_layer_usage
 
    
	
end
