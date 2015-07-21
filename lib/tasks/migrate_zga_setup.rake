require 'rubygems'
require 'pg'
require 'active_record'
require 'csv'


namespace :migrate_zga do 


  task :user => :environment do  
    
    admin_role = Role.find_by_name ROLE_NAME[:admin]
    if admin_role.nil?
      role = {
        'system' => {
          'administrator' => true
        }
      }
      
      admin_role = Role.create!(
        :name        => ROLE_NAME[:admin],
        :title       => 'Administrator',
        :description => 'Role for administrator',
        :the_role    => role.to_json
      )
    end


    
    migration_filename = MIGRATION_FILENAME[:user]
    original_location =   original_file_location( migration_filename )
    lookup_location =  lookup_file_location(  migration_filename ) 
    
    result_array = [] 
    awesome_row_counter = - 1 
    
    
    CSV.open(original_location, 'r') do |csv| 
        csv.each do |row|
            awesome_row_counter = awesome_row_counter + 1  
            next if awesome_row_counter == 0 
            
            id = row[0]
            username = row[1]
            password = row[2]
            name = row[3]
            description = row[4] 

 
            
            is_deleted = false
            is_deleted = true if row[6] == "True"
            
            next if is_deleted  
            
  
            object = User.create_object( 
                    :name => name ,
                    :email => "#{username}@gmail.com"  ,
                    :role_id => admin_role.id 
                )
                
            object.errors.messages.each {|x| puts "Error: #{x}" } 
            
            object.password = 'willy1234'
            object.password_confirmation = 'willy1234'
            object.save 
                

            result_array << [ id , object.id , object.name, object.email ] 
        end
    end
     
 
    # write the new csv LOOKUP file ( with mapping for the ID )
    CSV.open(lookup_location, 'w') do |csv|
      result_array.each do |el| 
        csv <<  el 
      end
    end
    
    puts "Done migrating user. Total user: #{User.count}"
  end
  

  
  task :employee => :environment do
    
    
    migration_filename = MIGRATION_FILENAME[:employee]
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
          address = row[2]
          contact_no = row[3]
          email = row[4]
          description = row[5]
          is_deleted = row[6]
          created_at = row[7]
          updated_at = row[8]
          deleted_at = row[9]
          
          is_deleted = false
          is_deleted = true if row[6] == "True"
              
          next if is_deleted
          
          
          object = Employee.create_object(
            :name       => name  , 
            :contact_no => contact_no, 
            :address    => address, 
            :email      => email, 
            :description => description
            
            )
            
            employee_count = Employee.count
            
            # puts "The employee_count is : #{employee_count}"
            
            
          object.errors.messages.each {|x| puts "Error: #{x}" } 
          
           

          result_array << [ id , 
                    object.id , 
                    object.name,  
                    object.contact_no, 
                    object.address,
                    object.email,
                    object.description
                    ]
        end
    end
    
    CSV.open(lookup_location, 'w') do |csv|
      result_array.each do |el| 
        csv <<  el 
      end
    end
    
    puts "Done migrating employee. Total employee: #{Employee.count}"
  end
end