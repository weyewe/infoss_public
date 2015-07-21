
json.success true 
json.total @total
 

json.records @objects do |object|
    
    
  json.id 								object.id  
	json.blanket_order_id 			 object.blanket_order_id
	json.blanket_id 			 object.blanket_id
	json.blanket_sku 			 object.blanket.sku
	json.blanket_name 			 object.blanket.name
	json.blanket_roll_blanket_item_id 			 object.blanket.roll_blanket_item_id
	json.blanket_roll_blanket_item_name 			 object.blanket.roll_blanket_item.name
	json.blanket_roll_blanket_item_sku   	 object.blanket.roll_blanket_item.sku
	json.blanket_left_bar_item_id		 object.blanket.left_bar_item_id
	
	if object.blanket.left_bar_item.nil?
		json.blanket_left_bar_item_name		 ""
		json.blanket_left_bar_item_sku		 ""
	else
		json.blanket_left_bar_item_name		 object.blanket.left_bar_item.name
		json.blanket_left_bar_item_sku		 object.blanket.left_bar_item.sku
	end
	json.blanket_right_bar_item_id		 object.blanket.right_bar_item_id
	
	if object.blanket.right_bar_item.nil?
		json.blanket_right_bar_item_name		 ""
		json.blanket_right_bar_item_sku		 ""
	else
		json.blanket_right_bar_item_name		 object.blanket.right_bar_item.name
		json.blanket_right_bar_item_sku		 object.blanket.right_bar_item.sku
	end
	json.total_cost		 object.total_cost
	json.is_cut		 object.is_cut
	json.is_side_sealed		 object.is_side_sealed
	json.is_bar_prepared		 object.is_bar_prepared
	json.is_adhesive_tape_applied		 object.is_adhesive_tape_applied
	json.is_bar_mounted		 object.is_bar_mounted
	json.is_bar_heat_pressed		 object.is_bar_heat_pressed
	json.is_bar_pull_off_tested		 object.is_bar_pull_off_tested
	json.is_qc_and_marked		 object.is_qc_and_marked
	json.is_packaged		 object.is_packaged
	json.is_rejected		 object.is_rejected
	json.rejected_date		 object.rejected_date
	json.is_job_scheduled		 object.is_job_scheduled
	json.is_finished		 object.is_finished
	json.finished_at		 object.finished_at
	json.bar_cost		 object.bar_cost
	json.adhesive_cost		 object.adhesive_cost
	json.roll_blanket_cost		 object.roll_blanket_cost
	json.roll_blanket_usage		 object.roll_blanket_usage
	json.roll_blanket_defect		 object.roll_blanket_defect
	
	
end
