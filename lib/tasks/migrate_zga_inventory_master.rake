require 'rubygems'
require 'pg'
require 'active_record'
require 'csv'


namespace :migrate_zga do 
  
  task :machine => :environment do   
    migration_filename = MIGRATION_FILENAME[:machine]
    original_location =   original_file_location( migration_filename )
    lookup_location =  lookup_file_location(  migration_filename ) 
    
    result_array = [] 
    awesome_row_counter = - 1 
    
    
    CSV.open(original_location, 'r') do |csv| 
        csv.each do |row|
            awesome_row_counter = awesome_row_counter + 1  
            next if awesome_row_counter == 0 
                        
            id = row[0]
            code = row[1]
            name = row[2]
            description = row[3] 
            
            is_deleted = false
            is_deleted = true if row[4] == "True"
            
            next if is_deleted  
            
  
            object = Machine.create_object( 
                    :code => code,
                    :name => name, 
                    :description => description 
                )
                
            object.errors.messages.each {|x| puts "Error: #{x}" } 
                

            result_array << [ id , object.id , object.code, object.name, object.description ] 
        end
    end
     
 
    # write the new csv LOOKUP file ( with mapping for the ID )
    CSV.open(lookup_location, 'w') do |csv|
      result_array.each do |el| 
        csv <<  el 
      end
    end
    
    puts "Done migrating machine. Total machine: #{Machine.count}"
  end

  task :uom => :environment do  
    migration_filename = MIGRATION_FILENAME[:uom]
    original_location =   original_file_location( migration_filename )
    lookup_location =  lookup_file_location(  migration_filename ) 
    
    result_array = [] 
    awesome_row_counter = - 1 
    
    
    CSV.open(original_location, 'r') do |csv| 
        csv.each do |row|
            awesome_row_counter = awesome_row_counter + 1  
            next if awesome_row_counter == 0 
                        
            id = row[0]
            name = row[1] 
 
            
            is_deleted = false
            is_deleted = true if row[3] == "True"
            
            next if is_deleted  
            
  
            object = Uom.create_object( 
                    :name => name  
                )
                
            object.errors.messages.each {|x| puts "Error: #{x}" } 
                

            result_array << [ id , object.id , object.name ] 
        end
    end
     
 
    # write the new csv LOOKUP file ( with mapping for the ID )
    CSV.open(lookup_location, 'w') do |csv|
      result_array.each do |el| 
        csv <<  el 
      end
    end
    
    puts "Done migrating uom. Total uom: #{Uom.count}"
  end
  
 
  

  
  task :item_type => :environment do
    
    account_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:coa] )  
    
    base_item_type_name = []
    
    BASE_ITEM_TYPE.each do |key,value| 
      base_item_type_name << value 
    end
    
 
    
    
    migration_filename = MIGRATION_FILENAME[:item_type]
    original_location =   original_file_location( migration_filename )
    lookup_location =  lookup_file_location(  migration_filename ) 
    result_array = [] 
    awesome_row_counter = - 1 
    
    CSV.open(original_location, 'r') do |csv| 
        csv.each do |row| 
          awesome_row_counter = awesome_row_counter + 1  
          next if awesome_row_counter == 0 
          
          id = row[0]
          name = row[1]
          description = row[2]
          is_legacy = row[3]
          account_id = row[4]
          is_deleted = row[5]
          
           
          is_deleted = false 
          is_deleted  = true if row[5] == "True" 
          
          next if is_deleted 
          
           
     
          new_account_id =  account_mapping_hash[account_id] 
          
          if new_account_id.nil?
            puts "fark, no data in the mapper. old account id #{account_id}. name : #{name}"
          end
          
          next if new_account_id.nil? 
          
          if Account.find_by_id( new_account_id.to_i ).nil?
            puts "fucka.. id #{new_account_id} has no corresponding new contact group "
          end
          
           
          object = nil 
          # puts "name : #{name}"
          if not base_item_type_name.include?( name )
            # puts "not found in the base item type"
            object = ItemType.create_object(
              :name =>  name   ,
              :description => description  , 
              :account_id =>  new_account_id.to_i , 
              )
          else
            # puts "found item type : #{name}"
            object = ItemType.find_by_name name 
            # puts "the object"
            # puts "#{object}"
            
          end
            
          object.errors.messages.each {|x| puts "error message: #{x}" }  
            
          
           

            result_array << [ id , 
                    object.id , 
                    object.name,  
                    object.description , 
                    object.account_id   ]
        end
    end
    
    CSV.open(lookup_location, 'w') do |csv|
      result_array.each do |el| 
        csv <<  el 
      end
    end
    
    puts "Done migrating item type. Total ItemType: #{ItemType.count}"
  end
  
  
  task :sub_type => :environment do
    
    item_type_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:item_type] )  
    
    migration_filename = MIGRATION_FILENAME[:sub_type]
    original_location =   original_file_location( migration_filename )
    lookup_location =  lookup_file_location(  migration_filename ) 
    result_array = [] 
    awesome_row_counter = - 1 
    
    CSV.open(original_location, 'r') do |csv| 
        csv.each do |row| 
          awesome_row_counter = awesome_row_counter + 1  
          next if awesome_row_counter == 0 
          
          id = row[0]
          name = row[1]
          item_type_id = row[2] 
          
          is_deleted = false 
          is_deleted  = true if row[3] == "True" 
          
          next if is_deleted 
          
           
     
          new_item_type_id =  item_type_mapping_hash[item_type_id] 
          
          if new_item_type_id.nil?
            puts "fark, no data in the mapper. old item_type id #{item_type_id}. name : #{name}"
          end
          
          
  
          
           
          object = SubType.create_object(
              :name =>   name , 
              :item_type_id =>  new_item_type_id 
            )
            
          object.errors.each {|x| puts "error message: #{x}" }  
            
          
           

            result_array << [ id , 
                    object.id , 
                    object.name,  
                    object.item_type_id   ]
        end
    end
    
    CSV.open(lookup_location, 'w') do |csv|
      result_array.each do |el| 
        csv <<  el 
      end
    end
    
    puts "Done migrating SubType. Total SubType: #{SubType.count}"
  end
  

  task :warehouse => :environment do  

    

    
    migration_filename = MIGRATION_FILENAME[:warehouse]
    original_location =   original_file_location( migration_filename )
    lookup_location =  lookup_file_location(  migration_filename ) 
    
    result_array = [] 
    awesome_row_counter = - 1
    
    CSV.open(original_location, 'r') do |csv| 
        csv.each do |row|
            awesome_row_counter = awesome_row_counter + 1  
            next if awesome_row_counter == 0 
            
            id = row[0]
            code = row[1]
            name = row[2]
            description = row[3]
            is_deleted = row[4]
 
             
            
            is_deleted = false
            is_deleted = true if row[4] == "True" 
            next if is_deleted  
             
              
 
            object = Warehouse.create_object(
              :name => name ,
              :description => code ,
              :code => code 
              )
              
            object.errors.messages.each {|x| puts "id: #{id}. error: #{x}" }
      

            result_array << [ id , object.id  ] 
        end
    end
     
 
    # write the new csv LOOKUP file ( with mapping for the ID )
    CSV.open(lookup_location, 'w') do |csv|
      result_array.each do |el| 
        csv <<  el 
      end
    end
    
    puts "Done migrating exchange. Total exchange: #{Exchange.count}"
  end
  
end