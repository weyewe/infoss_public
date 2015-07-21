require 'rubygems'
require 'pg'
require 'active_record'
require 'csv'




namespace :migrate_zga do 

  task :contact_group => :environment do  
    
    migration_filename = MIGRATION_FILENAME[:contact_group]
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
            
            is_deleted = false
            is_deleted = true if row[3] == "True"
            
            next if is_deleted  
            
  
            object = ContactGroup.create_object( 
                    :name => name ,
                    :description => description 
                )
                

            result_array << [ id , object.id , object.name, object.description ] 
        end
    end
     
 
    # write the new csv LOOKUP file ( with mapping for the ID )
    CSV.open(lookup_location, 'w') do |csv|
      result_array.each do |el| 
        csv <<  el 
      end
    end
    
    puts "Done migrating contact group. Total contact_group: #{ContactGroup.count}"
  end
  

  
  task :contact => :environment do
    
    contact_group_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:contact_group] ) 
    # puts "the contact group mapping hash"
    # puts "#{contact_group_mapping_hash}"
    
    migration_filename = MIGRATION_FILENAME[:contact]
    original_location =   original_file_location( migration_filename )
    lookup_location =  lookup_file_location(  migration_filename ) 
    result_array = [] 
    awesome_row_counter = - 1 
    
    CSV.open(original_location, 'r') do |csv| 
        csv.each do |row| 
          awesome_row_counter = awesome_row_counter + 1  
          next if awesome_row_counter == 0 
          
          id = row[0]
          contact_group_id = row[1]
          name = row[2]
          nama_faktur_pajak = row[3]
          address = row[4]
          delivery_address = row[5]
          npwp = row[6]
          description = row[7]
          contact_no = row[8]
          pic = row[9]
          pic_contact_no = row[10]
          email = row[11]
          
          is_taxable = row[12]
          is_taxable = false 
          is_taxable  = true if row[12] == "True" 
          
          tax_code = row[13]
          
          contact_type = row[14]
          # puts "The contact_type: #contact_type}"
          if not contact_type.nil? and not contact_type.length == 0  and contact_type.downcase == "customer"
            contact_type = CONTACT_TYPE[:customer].to_s
          else
            contact_type = CONTACT_TYPE[:supplier].to_s
          end
          
          
          default_payment_term = row[15]
          
          # puts "The row[16]: #{row[16]}"
          is_deleted = false 
          is_deleted  = true if row[16] == "True" 
          
          next if is_deleted 
          
           
    
          # puts "contact_group_id : #{contact_group_id}"
          new_contact_group_id =  contact_group_mapping_hash[contact_group_id]
          # puts "new_contact_group_id: #{new_contact_group_id}"
          
          if ContactGroup.find_by_id( new_contact_group_id.to_i ).nil?
            puts "fucka.. id #{contact_group_id} has no corresponding new contact group "
          end
          
          
          
          # puts "Before create object >>>>>>>>>> contact_type is :#{contact_type} "
          object = Contact.create_object(
              :name => name ,
              :address => address,
              :contact_no => contact_no,
              :delivery_address => delivery_address,
              :description => description,
              :default_payment_term =>  default_payment_term , 
              :npwp => npwp, 
              :is_taxable => is_taxable,  
              :tax_code => tax_code,
              :nama_faktur_pajak => nama_faktur_pajak,
              :pic => pic,
              :pic_contact_no =>  pic_contact_no,
              :email => email,
              :contact_type => contact_type, 
              :contact_group_id => new_contact_group_id
            
            )
            
          
           

            result_array << [ id , 
                    object.id , 
                    object.name, 
                    object.address,
                    object.contact_no, 
                    object.delivery_address,
                    object.description, 
                    object.default_payment_term,
                    object.npwp,
                    object.is_taxable, 
                    object.tax_code,
                    object.nama_faktur_pajak,
                    object.pic,
                    object.pic_contact_no,
                    object.email,
                    object.contact_type,
                    object.contact_group_id  ]
        end
    end
    
    CSV.open(lookup_location, 'w') do |csv|
      result_array.each do |el| 
        csv <<  el 
      end
    end
    
    puts "Done migrating contact. Total contact: #{Contact.count}"
  end
end