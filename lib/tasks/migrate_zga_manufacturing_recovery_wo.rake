require 'rubygems'
require 'pg'
require 'active_record'
require 'csv'


namespace :migrate_zga do 
  
   
  task :recovery_order => :environment do  

    warehouse_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:warehouse] )
    
    roller_identification_form_mapping_hash =  get_mapping_hash(  MIGRATION_FILENAME[:roller_identification_form] )  
    
      
    
    
    migration_filename = MIGRATION_FILENAME[:recovery_order]
    original_location =   original_file_location( migration_filename )
    lookup_location =  lookup_file_location(  migration_filename ) 
    
    result_array = []
    confirm_result_array = [] 
    awesome_row_counter = - 1
    
    
    
    CSV.open(original_location, 'r') do |csv| 
        csv.each do |row|
            awesome_row_counter = awesome_row_counter + 1  
            next if awesome_row_counter == 0 
            
            id = row[0]
            roller_identification_form_id = row[1]
            warehouse_id = row[2]
            code = row[3]
            quantity_received = row[4]
            quantity_rejected = row[5]
            quantity_final = row[6]
            is_confirmed = row[7]
            has_due_date = row[8]
            due_date = row[9]
            confirmation_date = row[10]
            is_completed = row[11]
            is_deleted = row[12]
       
            is_deleted = get_truth_value( row[12] )
            next if is_deleted  
            
          
            is_confirmed = get_truth_value( row[7] )
            has_due_date =  get_truth_value( row[8] )
             
            new_warehouse_id =  warehouse_mapping_hash[warehouse_id]
            new_roller_identification_form_id =  roller_identification_form_mapping_hash[roller_identification_form_id] 
            
            if new_warehouse_id.nil?
              puts "the  new_warehouse_id is nil, from old value: #{warehouse_id}"
              next 
            end
            
            
            if new_roller_identification_form_id.nil?
              puts "the  new_roller_identification_form_id is nil, from old value: #{roller_identification_form_id}"
              next 
            end
            
     
            parsed_due_date = get_parsed_date(due_date) 
 
            object =   RecoveryOrder.create_object(
              :roller_identification_form_id =>  new_roller_identification_form_id,
              :warehouse_id => new_warehouse_id,
              :code => code,
              :has_due_date => has_due_date,
              :due_date => parsed_due_date,
              )
                
            object.errors.messages.each {|x| puts "Error: #{x}" } 
                

            result_array << [ id , object.id   ] 
            if is_confirmed
              confirm_result_array << [object.id, object.class.to_s, confirmation_date ]
            end
            
        end
    end
     
 
    # write the new csv LOOKUP file ( with mapping for the ID )
    CSV.open(lookup_location, 'w') do |csv|
      result_array.each do |el| 
        csv <<  el 
      end
    end
    
    migration_filename = MIGRATION_FILENAME[:recovery_order_confirm] 
    confirm_lookup_location =  lookup_file_location(  migration_filename ) 
    
    CSV.open(confirm_lookup_location, 'w') do |csv|
      confirm_result_array.each do |el| 
        csv <<  el 
      end
    end
    
    puts "Done migrating RecoveryOrder. Total RecoveryOrder: #{RecoveryOrder.count}"
  end
  
   
  task :recovery_order_detail => :environment do  

    recovery_order_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:recovery_order] )  
    roller_identification_form_detail_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:roller_identification_form] )  
    roller_builder_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:roller_builder] )   
  
     
 
    migration_filename = MIGRATION_FILENAME[:recovery_order_detail]
    original_location =   original_file_location( migration_filename )
    lookup_location =  lookup_file_location(  migration_filename ) 
    
    result_array = []
    confirm_result_array = [] 
    awesome_row_counter = - 1
    
    
    
    CSV.open(original_location, 'r') do |csv| 
        csv.each do |row|
            awesome_row_counter = awesome_row_counter + 1  
            next if awesome_row_counter == 0 
                        
            id = row[0]
            recovery_order_id = row[1]
            roller_identification_form_detail_id = row[2]
            roller_builder_id = row[3]
            compound_under_layer_id = row[4]
            total_cost = row[5]
            accessories_cost = row[6]
            core_cost = row[7]
            compound_cost = row[8]
            compound_usage = row[9]
            compound_under_layer_usage = row[10]
            core_type_case = row[11]
            is_disassembled = row[12]
            is_stripped_and_glued = row[13]
            is_wrapped = row[14]
            is_vulcanized = row[15]
            is_faced_off = row[16]
            is_conventional_grinded = row[17]
            is_c_n_c_grinded = row[18]
            is_polished_and_q_c = row[19]
            is_packaged = row[20]
            is_rejected = row[21]
            rejected_date = row[22]
            is_finished = row[23]
            finished_date = row[24]
            is_deleted = row[25]
                      
            is_deleted = get_truth_value( row[25] )
            next if is_deleted  
            
            is_service = false
            is_service = true if row[9] == "True" 
            
 
  
            
 
            if not core_type_case.present?
              puts "Fuck bro.. core_type_case is not present. Find some way. old_id: #{id}"
              next
            end
            
            old_core_type_case = core_type_case.dup
            core_type_case  = CORE_TYPE_CASE[:r] if old_core_type_case ==  "R"
            core_type_case  = CORE_TYPE_CASE[:z] if old_core_type_case ==  "Z"
            
 
    
     
            new_recovery_order_id =  recovery_order_mapping_hash[recovery_order_id]
            new_roller_identification_form_detail_id =  roller_identification_form_detail_mapping_hash[ roller_identification_form_detail_id]
            new_roller_builder_id = roller_builder_mapping_hash[roller_builder_id] 
             
  
            
            if new_recovery_order_id.nil?
              puts "the  new_recovery_order_id is nil, from old value: #{recovery_order_id}"
              next 
            end
            
            if new_roller_identification_form_detail_id.nil?
              puts "the  new_roller_identification_form_detail_id is nil, from old value: #{roller_identification_form_detail_id}"
              next 
            end
            
            if new_roller_builder_id.nil?
              puts "the  new_roller_builder_id is nil, from old value: #{roller_builder_id}"
              next 
            end
      
   
   
            object = RecoveryOrderDetail.create_object(
                :recovery_order_id =>  new_recovery_order_id,
                :roller_identification_form_detail_id =>  new_roller_identification_form_detail_id,
                :roller_builder_id => new_roller_builder_id,
                :core_type_case => core_type_case
                ) 
                
            object.errors.messages.each {|x| puts "Error: #{x}" } 
            
   

            result_array << [ id , object.id   ] 
 
            
        end
    end
     
 
    # write the new csv LOOKUP file ( with mapping for the ID )
    CSV.open(lookup_location, 'w') do |csv|
      result_array.each do |el| 
        csv <<  el 
      end
    end
    

    puts "Done migrating RecoveryOrderDetail. Total RecoveryOrderDetail: #{RecoveryOrderDetail.count}"
  end
  
  task :confirm_recovery_order => :environment do 
    migration_filename = MIGRATION_FILENAME[:recovery_order_confirm]  
    lookup_location =  lookup_file_location(  migration_filename ) 
    
    CSV.open(lookup_location, 'r') do |csv| 
      csv.each do |row|
        id = row[0]
        confirmation_date_string = row[2] 
        parsed_confirmation_date = get_parsed_date(confirmation_date_string)
        
        object  = RecoveryOrder.find_by_id( id )
        
        object.confirm_object( :confirmed_at => parsed_confirmation_date  )  
        
        object.errors.messages.each {|x| puts "id: #{object.id}. Error: #{x}" } 
        
        
      end
    end
          
    puts "Total confirmed RecoveryOrder: #{RecoveryOrder.where(:is_confirmed => true).count}"
  end
  
   
  task :process_recovery_order_detail => :environment do  
    
    processed_counter = 0 
 
    item_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:item] )   
    recovery_order_detail_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:recovery_order_detail] )   
     
 
    migration_filename = MIGRATION_FILENAME[:recovery_order_detail]
    original_location =   original_file_location( migration_filename )
    lookup_location =  lookup_file_location(  migration_filename ) 
    
    result_array = []
    confirm_result_array = [] 
    awesome_row_counter = - 1
    
    
    
    CSV.open(original_location, 'r') do |csv| 
        csv.each do |row|
            awesome_row_counter = awesome_row_counter + 1  
            next if awesome_row_counter == 0 
                        
            id = row[0]
            recovery_order_id = row[1]
            roller_identification_form_detail_id = row[2]
            roller_builder_id = row[3]
            compound_under_layer_id = row[4]
            total_cost = row[5]
            accessories_cost = row[6]
            core_cost = row[7]
            compound_cost = row[8]
            compound_usage = row[9]
            compound_under_layer_usage = row[10]
            core_type_case = row[11]
            is_disassembled = row[12]
            is_stripped_and_glued = row[13]
            is_wrapped = row[14]
            is_vulcanized = row[15]
            is_faced_off = row[16]
            is_conventional_grinded = row[17]
            is_cnc_grinded = row[18]
            is_polished_and_q_c = row[19]
            is_packaged = row[20]
            is_rejected = row[21]
            rejected_date = row[22]
            is_finished = row[23]
            finished_date = row[24]
            is_deleted = row[25]
                      
            is_deleted = get_truth_value( row[25] )
            next if is_deleted  
            
            is_service = false
            is_service = true if row[9] == "True" 
            
            
            new_recovery_order_detail_id = recovery_order_detail_mapping_hash[ id ] 
            
            if new_recovery_order_detail_id.nil?
              puts "Howdy, no new_recovery_order_detail_id for old id: #{id}"
              next
            end
 
  
            
 
            
            new_compound_under_layer_id = item_mapping_hash[compound_under_layer_id] 
  
            
    
            if new_compound_under_layer_id.nil?
              puts "the  new_compound_under_layer_id is nil, from old value: #{compound_under_layer_id}"
              next 
            end
            
            object = RecoveryOrderDetail.find_by_id new_recovery_order_detail_id 
          
            is_deleted = get_truth_value( row[25] )
            
            is_disassembled =  get_truth_value( is_disassembled ) 
            is_stripped_and_glued = get_truth_value( is_stripped_and_glued ) 
            is_wrapped = get_truth_value( is_wrapped )  
            is_vulcanized = get_truth_value( is_vulcanized )  
            is_faced_off = get_truth_value( is_faced_off )  
            is_conventional_grinded = get_truth_value( is_conventional_grinded )  
            is_cnc_grinded = get_truth_value( is_cnc_grinded )  
            is_polished_and_gc = get_truth_value( is_polished_and_gc )  
            is_packaged = get_truth_value( is_packaged )  

            object.process_object(
              :compound_usage => compound_usage,
              :compound_under_layer_usage => compound_under_layer_usage, 
              :is_disassembled =>  is_disassembled, 
              :is_stripped_and_glued => is_stripped_and_glued, 
              :is_wrapped => is_wrapped, 
              :is_vulcanized => is_vulcanized, 
              :is_faced_off => is_faced_off, 
              :is_conventional_grinded => is_conventional_grinded, 
              :is_cnc_grinded => is_cnc_grinded, 
              :is_polished_and_gc => is_polished_and_gc, 
              :is_packaged => is_packaged, 
              :compound_under_layer_id => new_compound_under_layer_id
              )
              
            object.errors.messages.each {|x| puts "object: #{object.id}. error: #{msg}" } 
        
                
            if get_truth_value( is_finished ) or get_truth_value( is_rejected ) 
              result_array_row = []
              result_array_row << object.id 
              
              if object.is_finished
                result_array_row << "FINISH"
                result_array_row << finished_date
              elsif object.is_rejected
                result_array_row << "REJECT"
                result_array_row << rejected_date
              end
 
              
 
            
            
              result_array <<  result_array_row
            end
            
 
            
        end
    end
     
 
  
  
    processed_counter = 0 
    migration_filename = MIGRATION_FILENAME[:recovery_detail_finish_reject] 
    confirm_lookup_location =  lookup_file_location(  migration_filename ) 
    
    CSV.open(confirm_lookup_location, 'w') do |csv|
      result_array.each do |el| 
        csv <<  el 
        processed_counter = processed_counter  + 1 
      end
    end
    

    puts "Done processing RecoveryOrderDetail. Total processed RecoveryOrderDetail: #{processed_counter}"
  end
 

end
