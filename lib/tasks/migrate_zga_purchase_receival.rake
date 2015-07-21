require 'rubygems'
require 'pg'
require 'active_record'
require 'csv'


namespace :migrate_zga do 
  
   
  task :purchase_receival => :environment do  

    warehouse_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:warehouse] )
    purchase_order_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:purchase_order] )
     
  
    migration_filename = MIGRATION_FILENAME[:purchase_receival]
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
            purchase_order_id = row[2]
            receival_date = row[3]
            warehouse_id = row[4]
            nomor_surat = row[5]
            description = row[6]
            exchange_rate_amount = row[7]
            exchange_rate_id = row[8]
            total_c_o_g_s = row[9]
            total_amount = row[10]
            is_confirmed = row[11]
            confirmation_date = row[12]
            is_invoice_completed = row[13]
            is_deleted = row[14]
 
            
            is_deleted = false
            is_deleted = true if row[14] == "True" 
            next if is_deleted  
            
            is_confirmed = false
            is_confirmed = true if row[11] == "True" 
             
              
            new_warehouse_id =  warehouse_mapping_hash[warehouse_id]
            new_purchase_order_id =  purchase_order_mapping_hash[purchase_order_id] 
     
            parsed_receival_date = get_parsed_date(receival_date) 
 
            object =  PurchaseReceival.create_object(
              :warehouse_id =>  new_warehouse_id,
              :receival_date => parsed_receival_date ,
              :nomor_surat => nomor_surat,
              :purchase_order_id =>  new_purchase_order_id ,
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
    
    migration_filename = MIGRATION_FILENAME[:purchase_receival_confirm] 
    confirm_lookup_location =  lookup_file_location(  migration_filename ) 
    
    CSV.open(confirm_lookup_location, 'w') do |csv|
      confirm_result_array.each do |el| 
        csv <<  el 
      end
    end
    
    puts "Done migrating PurchaseReceival. Total PurchaseReceival: #{PurchaseReceival.count}"
  end
  
   
  task :purchase_receival_detail => :environment do  

    purchase_receival_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:purchase_receival] )  
    purchase_order_detail_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:purchase_order_detail] )  
    
       
    
    migration_filename = MIGRATION_FILENAME[:purchase_receival_detail]
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
            purchase_receival_id = row[2]
            item_id = row[3]
            quantity = row[4]
            is_all_invoiced = row[5]
            pending_invoiced_quantity = row[6]
            purchase_order_detail_id = row[7]
            c_o_g_s = row[8]
            is_confirmed = row[9]
            confirmation_date = row[10]
            is_deleted = row[11]
            
            is_deleted = false
            is_deleted = true if row[11] == "True" 
            next if is_deleted  
            
          
              
            new_purchase_receival_id =  purchase_receival_mapping_hash[purchase_receival_id]
            new_purchase_order_detail_id = purchase_order_detail_mapping_hash[purchase_order_detail_id]
            
            if new_purchase_receival_id.nil?
              puts "the new new_purchase_receival_id is nil, from old value: #{purchase_receival_id}"
              next 
            end
            
            if new_purchase_order_detail_id.nil?
              puts "the new_purchase_order_detail_id is nil, from old value: #{purchase_order_detail_id}"
              next
            end
   
            object = PurchaseReceivalDetail.create_object(
              :purchase_receival_id =>  new_purchase_receival_id ,
              :purchase_order_detail_id =>  new_purchase_order_detail_id,
              :amount => quantity 
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
    

    puts "Done migrating PurchaseReceivalDetail. Total PurchaseReceivalDetail: #{PurchaseReceivalDetail.count}"
  end
  
  task :confirm_purchase_receival => :environment do 
    migration_filename = MIGRATION_FILENAME[:purchase_receival_confirm]  
    lookup_location =  lookup_file_location(  migration_filename ) 
    
    CSV.open(lookup_location, 'r') do |csv| 
      csv.each do |row|
        id = row[0]
        confirmation_date_string = row[2] 
        parsed_confirmation_date = get_parsed_date(confirmation_date_string)
        
        object  = PurchaseReceival.find_by_id( id )
        
        object.confirm_object( :confirmed_at => parsed_confirmation_date  )  
        
        object.errors.messages.each {|x| puts "id: #{object.id}. Error: #{x}" } 
        
      end
    end
          
    puts "Total confirmed PurchaseReceival: #{PurchaseReceival.where(:is_confirmed => true).count}"
  end
 

end
