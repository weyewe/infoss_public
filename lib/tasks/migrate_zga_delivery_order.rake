require 'rubygems'
require 'pg'
require 'active_record'
require 'csv'


namespace :migrate_zga do 
  
   
  task :delivery_order => :environment do  

    warehouse_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:warehouse] )
    sales_order_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:sales_order] )
    
  
    migration_filename = MIGRATION_FILENAME[:delivery_order]
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
            sales_order_id = row[2]
            delivery_date = row[3]
            warehouse_id = row[4]
            nomor_surat = row[5]
 
            remark = row[8] 
            is_confirmed = row[10]
            confirmation_date = row[11]
            is_invoice_completed = row[12]
            is_deleted = row[13]
            
 
            
            is_deleted = false
            is_deleted = true if row[13] == "True" 
            next if is_deleted  
            
            is_confirmed = false
            is_confirmed = true if row[10] == "True" 
             
              
            new_warehouse_id =  warehouse_mapping_hash[warehouse_id]
            new_sales_order_id =  sales_order_mapping_hash[sales_order_id] 
     
            parsed_delivery_date = get_parsed_date(delivery_date) 
 
            object =  DeliveryOrder.create_object(
              :warehouse_id => new_warehouse_id,
              :delivery_date => parsed_delivery_date ,
              :nomor_surat => nomor_surat ,
              :sales_order_id => new_sales_order_id ,
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
    
    migration_filename = MIGRATION_FILENAME[:delivery_order_confirm] 
    confirm_lookup_location =  lookup_file_location(  migration_filename ) 
    
    CSV.open(confirm_lookup_location, 'w') do |csv|
      confirm_result_array.each do |el| 
        csv <<  el 
      end
    end
    
    puts "Done migrating DeliveryOrder. Total DeliveryOrder: #{DeliveryOrder.count}"
  end
  
   
  task :delivery_order_detail => :environment do  

    delivery_order_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:delivery_order] )  
    sales_order_detail_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:sales_order_detail] )  
 
            
    
    migration_filename = MIGRATION_FILENAME[:delivery_order_detail]
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
            order_type = row[2]
            order_code = row[3]
            delivery_order_id = row[4]
            item_id = row[5]
            quantity = row[6]
            is_all_invoiced = row[7]
            pending_invoiced_quantity = row[8]
            sales_order_detail_id = row[9]
            c_o_g_s = row[10]
            is_confirmed = row[11]
            confirmation_date = row[12]
            is_deleted = row[13]
 
            
            is_deleted = false
            is_deleted = true if row[13] == "True" 
            next if is_deleted  
            
          
              
            new_delivery_order_id =  delivery_order_mapping_hash[delivery_order_id]
            new_sales_order_detail_id = sales_order_detail_mapping_hash[sales_order_detail_id]
            
            if new_delivery_order_id.nil?
              puts "the new delivery_order_id is nil, from old value: #{delivery_order_id}"
              next 
            end
            
            if new_sales_order_detail_id.nil?
              puts "the new_sales_order_detail_id is nil, from old value: #{sales_order_detail_id}"
              next
            end
   
            object = DeliveryOrderDetail.create_object(
              :delivery_order_id => new_delivery_order_id ,
              :sales_order_detail_id =>  new_sales_order_detail_id,
              :amount =>  quantity 
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
    

    puts "Done migrating DeliveryOrderDetail. Total DeliveryOrderDetail: #{DeliveryOrderDetail.count}"
  end
  
  task :confirm_delivery_order => :environment do 
    migration_filename = MIGRATION_FILENAME[:delivery_order_confirm]  
    lookup_location =  lookup_file_location(  migration_filename ) 
    
    CSV.open(lookup_location, 'r') do |csv| 
      csv.each do |row|
        id = row[0]
        confirmation_date_string = row[2] 
        parsed_confirmation_date = get_parsed_date(confirmation_date_string)
        
        object  = DeliveryOrder.find_by_id( id )
        
        object.confirm_object( :confirmed_at => parsed_confirmation_date  )  
        
        object.errors.messages.each {|x| puts "id: #{object.id}. Error: #{x}" } 
        puts "Total confirmed DeliveryOrder: #{DeliveryOrder.where(:is_confirmed => true).count}"
      end
    end
          
  end
 

end
