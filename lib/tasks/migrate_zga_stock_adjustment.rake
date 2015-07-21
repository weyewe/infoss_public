require 'rubygems'
require 'pg'
require 'active_record'
require 'csv'


namespace :migrate_zga do 
  
   
  task :stock_adjustment => :environment do  

    warehouse_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:warehouse] )  
    
    migration_filename = MIGRATION_FILENAME[:stock_adjustment]
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
            warehouse_id = row[1]
            adjustment_date = row[2]
            description = row[3]
            code = row[4]
            total = row[5]
            is_confirmed = row[6]
            confirmation_date = row[7]
            is_deleted = row[8]
            
 
            
            is_deleted = false
            is_deleted = true if row[8] == "True" 
            next if is_deleted  
            
            is_confirmed = false
            is_confirmed = true if row[6] == "True" 
             
              
            new_warehouse_id =  warehouse_mapping_hash[warehouse_id]
            parsed_adjustment_date = get_parsed_date(adjustment_date)
          
 
            object = StockAdjustment.create_object(
              :warehouse_id => new_warehouse_id,
              :adjustment_date => parsed_adjustment_date,
              :description => description 
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
    
    migration_filename = MIGRATION_FILENAME[:stock_adjustment_confirm] 
    confirm_lookup_location =  lookup_file_location(  migration_filename ) 
    
    CSV.open(confirm_lookup_location, 'w') do |csv|
      confirm_result_array.each do |el| 
        csv <<  el 
      end
    end
    
    puts "Done migrating StockAdjustment. Total StockAdjustment: #{StockAdjustment.count}"
  end
  
   
  task :stock_adjustment_detail => :environment do  

    item_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:item] )  
    stock_adjustment_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:stock_adjustment] )  
    
    migration_filename = MIGRATION_FILENAME[:stock_adjustment_detail]
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
            stock_adjustment_id = row[1]
            item_id = row[2]
            code = row[3]
            quantity = row[4]
            price = row[5]
            is_confirmed = row[6]
            confirmation_date = row[7]
            is_deleted = row[8]
            
 
            
            is_deleted = false
            is_deleted = true if row[8] == "True" 
            next if is_deleted  
            
 
              
            new_stock_adjustment_id =  stock_adjustment_mapping_hash[stock_adjustment_id]
            new_item_id = item_mapping_hash[item_id]
 
            if new_stock_adjustment_id.nil?
              puts "the new stock adustment id is nil, from old value: #{stock_adjustment_id}"
              next 
            end
            
            if new_item_id.nil?
              puts "the new item id is nil, from old value: #{item_id}"
              next
            end
 
            adjustment_status = ADJUSTMENT_STATUS[:addition]
            
            if BigDecimal( quantity ) < BigDecimal("0")
              adjustment_status = ADJUSTMENT_STATUS[:deduction]
            end
            
            if BigDecimal( price ) == BigDecimal("0")
              price = BigDecimal('1')
            end
            
            object = StockAdjustmentDetail.create_object(
              :stock_adjustment_id => new_stock_adjustment_id ,
              :item_id =>  new_item_id ,
              :price => price ,
              :amount => quantity.to_i.abs,
              :status => adjustment_status
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
    

    puts "Done migrating StockAdjustmentDetail. Total StockAdjustmentDetail: #{StockAdjustmentDetail.count}"
  end
  
  task :confirm_stock_adjustment => :environment do 
    migration_filename = MIGRATION_FILENAME[:stock_adjustment_confirm]  
    lookup_location =  lookup_file_location(  migration_filename ) 
    
    CSV.open(lookup_location, 'r') do |csv| 
      csv.each do |row|
        id = row[0]
        confirmation_date_string = row[2] 
        parsed_confirmation_date = get_parsed_date(confirmation_date_string)
        
        object  = StockAdjustment.find_by_id( id )
        
        object.confirm_object( :confirmed_at => parsed_confirmation_date  )  
        
        object.errors.messages.each {|x| puts "id: #{object.id}. Error: #{x}" } 
        
      end
    end
          
    puts "Total confirmed StockAdjustment: #{StockAdjustment.where(:is_confirmed => true).count}"
  end
  
 

end
