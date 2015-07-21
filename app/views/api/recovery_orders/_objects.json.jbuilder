json.recovery_orders objects do |object|

  json.id 	object.id 
  json.roller_identification_form_id 	object.roller_identification_form_id 
  json.roller_identification_form_nomor_disasembly 	object.roller_identification_form.nomor_disasembly 
  json.roller_identification_form_code 	object.roller_identification_form.code 
  json.warehouse_id 	object.warehouse_id 
  json.warehouse_name 	object.warehouse.name 
  json.code 	object.code 
  json.amount_received 	object.amount_received 
  json.amount_rejected 	object.amount_rejected 
  json.amount_final 	object.amount_final 
  json.is_completed 	object.is_completed 
  json.is_confirmed 	object.is_confirmed 
  json.confirmed_at 	format_date_friendly( object.confirmed_at )  
  json.has_due_date 	object.has_due_date 
  json.due_date 	format_date_friendly( object.due_date )  
  
end


