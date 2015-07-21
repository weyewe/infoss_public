require 'rubygems'
require 'pg'
require 'active_record'
require 'csv'


namespace :migrate_zga do 
  
   
  task :exchange_rate => :environment do  

    exchange_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:exchange] ) 
  # puts "exchange_mapping_hash: >>>>>>>>>>>>>>>>>\n\n"
  # puts exchange_mapping_hash
    
    migration_filename = MIGRATION_FILENAME[:exchange_rate]
    original_location =   original_file_location( migration_filename )
    lookup_location =  lookup_file_location(  migration_filename ) 
    
    result_array = [] 
    awesome_row_counter = - 1
    
    CSV.open(original_location, 'r') do |csv| 
        csv.each do |row|
            awesome_row_counter = awesome_row_counter + 1  
            next if awesome_row_counter == 0 
            
            id = row[0]
            exchange_id = row[1]
            ex_rate_date = row[2]
            rate = row[3]
            is_deleted = row[4]
            
 
            
            is_deleted = false
            is_deleted = true if row[4] == "True" 
            next if is_deleted  
             
              
            new_exchange_id =  exchange_mapping_hash[exchange_id]
            

            parsed_ex_rate_date = get_parsed_date( ex_rate_date )
            object = ExchangeRate.create_object( 
                      :exchange_id => new_exchange_id,
                      :ex_rate_date => parsed_ex_rate_date,
                      :rate => rate  
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
    
    puts "Done migrating Exchange Rate. Total ExchangeRate: #{ExchangeRate.count}"
  end
  
 

end
