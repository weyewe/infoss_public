require 'rubygems'
require 'pg'
require 'active_record'
require 'csv'


namespace :migrate_zga do 
  
   
  task :sales_order => :environment do  

    warehouse_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:warehouse] )
    
    contact_mapping_hash =  get_mapping_hash(  MIGRATION_FILENAME[:contact] )
    exchange_mapping_hash =   get_mapping_hash(  MIGRATION_FILENAME[:exchange] )
    employee_mapping_hash =  get_mapping_hash(  MIGRATION_FILENAME[:employee] )
    
    migration_filename = MIGRATION_FILENAME[:sales_order]
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
            contact_id = row[4]
            sales_date = row[5]
            nomor_surat = row[6]
            exchange_id = row[7]
            employee_id = row[8]
            is_confirmed = row[9]
            confirmation_date = row[10]
            is_delivery_completed = row[11]
            is_deleted = row[12]
            
 
            
            is_deleted = false
            is_deleted = true if row[12] == "True" 
            next if is_deleted  
            
            is_confirmed = false
            is_confirmed = true if row[9] == "True" 
             
              
            new_contact_id =  contact_mapping_hash[contact_id]
            new_exchange_id =  exchange_mapping_hash[exchange_id]
            new_employee_id =  employee_mapping_hash[employee_id]
     
            parsed_sales_date = get_parsed_date(sales_date) 
 
            object =  SalesOrder.create_object(
              :contact_id => new_contact_id ,
              :employee_id => new_employee_id ,
              :sales_date => parsed_sales_date,
              :nomor_surat => nomor_surat,
              :exchange_id =>  new_exchange_id
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
    
    migration_filename = MIGRATION_FILENAME[:sales_order_confirm] 
    confirm_lookup_location =  lookup_file_location(  migration_filename ) 
    
    CSV.open(confirm_lookup_location, 'w') do |csv|
      confirm_result_array.each do |el| 
        csv <<  el 
      end
    end
    
    puts "Done migrating SalesOrder. Total SalesOrder: #{SalesOrder.count}"
  end
  
   
  task :sales_order_detail => :environment do  

    sales_order_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:sales_order] )  
    item_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:item] )  
    
    migration_filename = MIGRATION_FILENAME[:sales_order_detail]
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
            order_code = row[2]
            sales_order_id = row[3]
            item_id = row[4]
            quantity = row[5]
            is_all_delivered = row[6]
            pending_delivery_quantity = row[7]
            price = row[8]
            is_service = row[9]
            is_confirmed = row[10]
            confirmation_date = row[11]
            is_deleted = row[12]
 
            
            is_deleted = false
            is_deleted = true if row[12] == "True" 
            next if is_deleted  
            
            is_service = false
            is_service = true if row[9] == "True" 
            
 
              
            new_sales_order_id =  sales_order_mapping_hash[sales_order_id]
            new_item_id = item_mapping_hash[item_id]
            
            if new_sales_order_id.nil?
              puts "the new sales_orderid is nil, from old value: #{sales_order_id}"
              next 
            end
            
            if new_item_id.nil?
              puts "the new item id is nil, from old value: #{item_id}"
              next
            end
   
            object = SalesOrderDetail.create_object(
              :sales_order_id => new_sales_order_id,
              :item_id => new_item_id ,
              :amount => quantity ,
              :price => price,
              :is_service => SalesOrderDetail
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
    

    puts "Done migrating SalesOrderDetail. Total SalesOrderDetail: #{SalesOrderDetail.count}"
  end
  
  task :confirm_sales_order => :environment do 
    migration_filename = MIGRATION_FILENAME[:sales_order_confirm]  
    lookup_location =  lookup_file_location(  migration_filename ) 
    
    CSV.open(lookup_location, 'r') do |csv| 
      csv.each do |row|
        id = row[0]
        confirmation_date_string = row[2] 
        parsed_confirmation_date = get_parsed_date(confirmation_date_string)
        
        object  = SalesOrder.find_by_id( id )
        
        object.confirm_object( :confirmed_at => parsed_confirmation_date  )  
        
        object.errors.messages.each {|x| puts "id: #{object.id}. Error: #{x}" } 
        
        
      end
    end
          
    puts "Total confirmed SalesOrder: #{SalesOrder.where(:is_confirmed => true).count}"
  end
 

end
