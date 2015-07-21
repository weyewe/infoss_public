
json.blankets objects do |object|
	json.id     object.id  
	json.sku    object.sku
	json.name    object.name
	json.amount    object.amount
	json.description    object.description
	json.contact_id     object.contact_id  
	json.contact_name     object.contact.name
	json.machine_id   object.machine_id  
	json.machine_name     object.machine.name  
	json.adhesive_id    object.adhesive_id  
	if not object.adhesive_id == 0
		json.adhesive_name object.adhesive.name 
	else 
		json.adhesive_name ""
	end
	json.adhesive2_id     object.adhesive2_id  
	if not object.adhesive2_id == 0
		json.adhesive2_name object.adhesive2.name 
	else 
		json.adhesive2_name ""
	end
	json.roll_blanket_item_id     object.roll_blanket_item_id  
	json.roll_blanket_item_name     object.roll_blanket_item.name
	json.left_bar_item_id     object.left_bar_item_id  
	if not object.left_bar_item_id == 0
		json.left_bar_item_name object.left_bar_item.name 
	else 
		json.left_bar_item_name ""
	end
	if not object.right_bar_item_id == 0
		json.right_bar_item_name object.right_bar_item_id.name 
	else 
		json.right_bar_item_name ""
	end
	json.ac     object.ac  
	json.ar     object.ar  
	json.thickness    object.thickness  
	json.ks     object.ks  
	json.is_bar_required    object.is_bar_required  
	json.has_left_bar     object.has_left_bar  
	json.has_right_bar    object.has_right_bar  
	json.cropping_type    object.cropping_type  
	json.left_over_ac     object.left_over_ac  
	json.special    object.special  
	json.application_case     object.application_case  
end


