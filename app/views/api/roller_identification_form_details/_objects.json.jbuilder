json.roller_identification_form_details objects do |object|
    
    json.id 	object.id  
    json.roller_identification_form_id 	object.roller_identification_form_id  
    json.detail_id 	object.detail_id  
    json.material_case 	object.material_case  
    json.core_builder_id 	object.core_builder_id
    json.core_builder_sku 	object.core_builder.base_sku  
    json.core_builder_name 	object.core_builder.name  
    json.roller_type_id 	object.roller_type_id
    json.roller_type_name 	object.roller_type.name
    json.machine_id 	object.machine_id
    json.machine_name 	object.machine.name
    json.repair_request_case 	object.repair_request_case
    if object.repair_request_case == 1
  		json.repair_request_case_text  "Bearing Set"
  	elsif object.repair_request_case == 2
  		json.repair_request_case_text  "Centre Drill"
  	elsif object.repair_request_case == 3
  		json.repair_request_case_text  "None"
  	elsif object.repair_request_case == 4
	  	json.repair_request_case_text  "Bearing Set and Centre Drill"
	  elsif object.repair_request_case == 5
	  	json.repair_request_case_text  "Repair Corosive"
	  elsif object.repair_request_case == 6
	  	json.repair_request_case_text  "Bearing Set and Repair Corosive"
	  elsif object.repair_request_case == 7
	  	json.repair_request_case_text  "Centre Drill and Repair Corosive"
	  else 
	  	json.repair_request_case_text  "All"	
  	end
  	json.rd 	object.rd
  	json.cd 	object.cd
  	json.rl 	object.rl
  	json.wl 	object.wl
  	json.tl 	object.tl
  	json.is_job_scheduled 	object.is_job_scheduled
  	json.is_delivered 	object.is_delivered
  	json.is_roller_built 	object.is_roller_built
  	json.is_confirmed 	object.is_confirmed
  	json.confirmed_at 	format_date_friendly( object.confirmed_at )
  	json.roller_no 	object.roller_no
  	json.gl 	object.gl
  	json.groove_length 	object.groove_length
  	json.groove_amount 	object.groove_amount
end
