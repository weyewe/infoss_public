require 'rubygems'
require 'pg'
require 'active_record'
require 'csv'


namespace :migrate_zga do 
  
   
  task :purchase_order => :environment do  

    warehouse_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:warehouse] )
    
    contact_mapping_hash =  get_mapping_hash(  MIGRATION_FILENAME[:contact] )
    exchange_mapping_hash =   get_mapping_hash(  MIGRATION_FILENAME[:exchange] )
    employee_mapping_hash =  get_mapping_hash(  MIGRATION_FILENAME[:employee] )
    
    migration_filename = MIGRATION_FILENAME[:purchase_order]
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
            contact_id = row[2]
            purchase_date = row[3]
            nomor_surat = row[4]
            exchange_id = row[5]
            description = row[6]
            allow_edit_detail = row[7]
            is_confirmed = row[8]
            confirmation_date = row[9]
            is_receival_completed = row[10]
            is_deleted = row[11]
 
            
            is_deleted = false
            is_deleted = true if row[11] == "True" 
            next if is_deleted  
            
            is_confirmed = false
            is_confirmed = true if row[8] == "True" 
            
            allow_edit_detail = false
            allow_edit_detail = true if row[7] == "True" 
             
              
            new_contact_id =  contact_mapping_hash[contact_id]
            new_exchange_id =  exchange_mapping_hash[exchange_id] 
     
            parsed_purchase_date = get_parsed_date(purchase_date) 
 
            object =  PurchaseOrder.create_object(
              :contact_id =>  new_contact_id  ,
              :purchase_date => parsed_purchase_date ,
              :nomor_surat => nomor_surat,
              :allow_edit_detail =>  allow_edit_detail,
              :description => description,
              :exchange_id => new_exchange_id 
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
    
    migration_filename = MIGRATION_FILENAME[:purchase_order_confirm] 
    confirm_lookup_location =  lookup_file_location(  migration_filename ) 
    
    CSV.open(confirm_lookup_location, 'w') do |csv|
      confirm_result_array.each do |el| 
        csv <<  el 
      end
    end
    
    puts "Done migrating PurchaseOrder. Total PurchaseOrder: #{PurchaseOrder.count}"
  end
  
   
  task :purchase_order_detail => :environment do  

    purchase_order_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:purchase_order] )  
    item_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:item] )  
    
   
            
    
    migration_filename = MIGRATION_FILENAME[:purchase_order_detail]
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
            item_id = row[3]
            quantity = row[4]
            is_all_received = row[5]
            pending_receival_quantity = row[6]
            price = row[7]
            is_confirmed = row[8]
            confirmation_date = row[9]
            is_deleted = row[10]
 
            
            is_deleted = false
            is_deleted = true if row[10] == "True" 
            next if is_deleted  
            
   
              
            new_purchase_order_id =  purchase_order_mapping_hash[purchase_order_id]
            new_item_id = item_mapping_hash[item_id]
            
            if new_purchase_order_id.nil?
              puts "the new new_purchase_order_id is nil, from old value: #{purchase_order_id}"
              next 
            end
            
            if new_item_id.nil?
              puts "the new item id is nil, from old value: #{item_id}"
              next
            end
   
            object =  PurchaseOrderDetail.create_object(
              :purchase_order_id =>  new_purchase_order_id ,
              :item_id =>  new_item_id ,
              :amount => quantity ,
              :price => price 
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
    

    puts "Done migrating PurchaseOrderDetail. Total PurchaseOrderDetail: #{PurchaseOrderDetail.count}"
  end
  
  task :confirm_purchase_order => :environment do 
    migration_filename = MIGRATION_FILENAME[:purchase_order_confirm]  
    lookup_location =  lookup_file_location(  migration_filename ) 
    
    CSV.open(lookup_location, 'r') do |csv| 
      csv.each do |row|
        id = row[0]
        confirmation_date_string = row[2] 
        parsed_confirmation_date = get_parsed_date(confirmation_date_string)
        
        object  = PurchaseOrder.find_by_id( id )
        
        object.confirm_object( :confirmed_at => parsed_confirmation_date  )  
        
        object.errors.messages.each {|x| puts "id: #{object.id}. Error: #{x}" } 
        
      end
    end
          
    puts "Total confirmed PurchaseOrder: #{PurchaseOrder.where(:is_confirmed => true).count}"
  end
 

end
