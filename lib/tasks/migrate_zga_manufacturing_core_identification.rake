require 'rubygems'
require 'pg'
require 'active_record'
require 'csv'


namespace :migrate_zga do 
  
   
  task :roller_identification_form => :environment do  

    warehouse_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:warehouse] )
    
    contact_mapping_hash =  get_mapping_hash(  MIGRATION_FILENAME[:contact] )  
    
    migration_filename = MIGRATION_FILENAME[:roller_identification_form]
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
            code = row[1]
            nomor_disassembly = row[2]
            warehouse_id = row[3]
            contact_id = row[4]
            is_in_house = row[5]
            quantity = row[6]
            identified_date = row[7]
            is_confirmed = row[8]
            confirmation_date = row[9]
            incoming_roll = row[10]
            is_completed = row[11]
            is_deleted = row[12]
 
       
            is_deleted = get_truth_value( row[12] )
            next if is_deleted  
            
          
            is_confirmed = get_truth_value( row[8] )
             
            new_warehouse_id =  warehouse_mapping_hash[warehouse_id]
            new_contact_id =  contact_mapping_hash[contact_id] 
            
            if new_warehouse_id.nil?
              puts "the  new_warehouse_id is nil, from old value: #{warehouse_id}"
              next 
            end
            
            
            if new_contact_id.nil?
              puts "the  new_contact_id is nil, from old value: #{contact_id}"
              next 
            end
            
     
            parsed_identified_date = get_parsed_date(identified_date) 
 
            object =   RollerIdentificationForm.create_object(
              :warehouse_id => new_warehouse_id,
              :contact_id =>  new_contact_id,
              :is_in_house => is_in_house ,
              :amount => quantity.to_i,
              :identified_date =>  parsed_identified_date ,
              :nomor_disasembly =>  nomor_disassembly
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
    
    migration_filename = MIGRATION_FILENAME[:roller_identification_form_confirm] 
    confirm_lookup_location =  lookup_file_location(  migration_filename ) 
    
    CSV.open(confirm_lookup_location, 'w') do |csv|
      confirm_result_array.each do |el| 
        csv <<  el 
      end
    end
    
    puts "Done migrating RollerIdentificationForm. Total RollerIdentificationForm: #{RollerIdentificationForm.count}"
  end
  
   
  task :roller_identification_form_detail => :environment do  

    roller_identification_form_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:roller_identification_form] )  
    core_builder_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:core_builder] )  
    roller_type_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:roller_type] )  
    machine_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:machine] )  
    
 
    migration_filename = MIGRATION_FILENAME[:roller_identification_form_detail]
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
            roller_no = row[1]
            core_identification_id = row[2]
            detail_id = row[3]
            material_case = row[4]
            core_builder_id = row[5]
            roller_type_id = row[6]
            machine_id = row[7]
            repair_request_case = row[8]
            rd = row[9]
            cd = row[10]
            rl = row[11]
            wl = row[12]
            tl = row[13]
            gl = row[14]
            groove_length = row[15]
            groove_qty = row[16]
            is_job_scheduled = row[17]
            is_delivered = row[18]
            is_roller_built = row[19]
            is_confirmed = row[20]
            confirmation_date = row[21]
            is_deleted = row[22]
            
          
            is_deleted = get_truth_value( row[22] )
            next if is_deleted  
            
            is_service = false
            is_service = true if row[9] == "True" 
            
 
              

            
 
            if not material_case.present?
              puts "Fuck bro.. material case is not present. Find some way. old_id: #{id}"
              next
            end
            
            if   not [
                MATERIAL_CASE[:new],
                MATERIAL_CASE[:used]
              ].include?( material_case.to_i )
              puts "Fuck bro.. material case is  present. But sick value. Find some way. old_id: #{id}"
              next
            end
       
            if not repair_request_case.present?
              puts "Fuck bro.. repair_request_case  is not present. Find some way. old_id: #{id}"
              next
            end
            
            if   not [
                REPAIR_REQUEST_CASE[:bearing_set],
                REPAIR_REQUEST_CASE[:centre_drill],
                REPAIR_REQUEST_CASE[:none],
                REPAIR_REQUEST_CASE[:bearing_set_and_centre_drill],
                REPAIR_REQUEST_CASE[:repair_corosive],
                REPAIR_REQUEST_CASE[:bearing_set_and_repair_corosive],
                REPAIR_REQUEST_CASE[:centre_drill_and_repair_corosive],
                REPAIR_REQUEST_CASE[:all]
                 
              ].include?( repair_request_case.to_i )
              puts "Fuck bro..  repair_request_case is  present. But sick value. Find some way. old_id: #{id}"
              next
            end
  
  
            new_roller_identification_form_id =  roller_identification_form_mapping_hash[core_identification_id]
            new_core_builder_id = core_builder_mapping_hash[ core_builder_id]
            new_roller_type_id = roller_type_mapping_hash[roller_type_id]
            new_machine_id = machine_mapping_hash[machine_id]
  
  
            
            if new_roller_identification_form_id.nil?
              puts "the  new_roller_identification_form_id is nil, from old value: #{roller_identification_form_id}"
              next 
            end
            
            if new_core_builder_id.nil?
              puts "the  new_core_builder_id is nil, from old value: #{core_builder_id}"
              next 
            end
            
            if new_roller_type_id.nil?
              puts "the  new_roller_type_id is nil, from old value: #{roller_type_id}"
              next 
            end
            
            if new_machine_id.nil?
              puts "the  new_machine_id is nil, from old value: #{machine_id}"
              next 
            end        
   
            object = RollerIdentificationFormDetail.create_object(
                :roller_identification_form_id => new_roller_identification_form_id,
                :detail_id => 1,
                :material_case => material_case  ,
                :core_builder_id =>  new_core_builder_id,
                :roller_type_id => new_roller_type_id ,
                :machine_id => new_machine_id,
                :repair_request_case =>  repair_request_case,
                :roller_no =>  roller_no ,
                :rd => rd,
                :cd => cd,
                :rl => rl,
                :wl => wl,
                :tl => tl,
                :gl => gl, 
                :groove_amount => groove_qty,
                :groove_length => groove_length
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
    

    puts "Done migrating RollerIdentificationFormDetail. Total RollerIdentificationFormDetail: #{RollerIdentificationFormDetail.count}"
  end
  
  task :confirm_roller_identification_form => :environment do 
    migration_filename = MIGRATION_FILENAME[:roller_identification_form_confirm]  
    lookup_location =  lookup_file_location(  migration_filename ) 
    
    CSV.open(lookup_location, 'r') do |csv| 
      csv.each do |row|
        id = row[0]
        confirmation_date_string = row[2] 
        parsed_confirmation_date = get_parsed_date(confirmation_date_string)
        
        object  = RollerIdentificationForm.find_by_id( id )
        
        object.confirm_object( :confirmed_at => parsed_confirmation_date  )  
        
        object.errors.messages.each {|x| puts "id: #{object.id}. Error: #{x}" } 
        
        
      end
    end
          
    puts "Total confirmed RollerIdentificationForm: #{RollerIdentificationForm.where(:is_confirmed => true).count}"
  end
 

end
