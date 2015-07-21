require 'rubygems'
require 'pg'
require 'active_record'
require 'csv'


namespace :migrate_zga do 
  
   
  task :payment_request => :environment do  

     
    
    contact_mapping_hash =  get_mapping_hash(  MIGRATION_FILENAME[:contact] )
    exchange_mapping_hash =   get_mapping_hash(  MIGRATION_FILENAME[:exchange] )
    account_mapping_hash =  get_mapping_hash(  MIGRATION_FILENAME[:coa] )
 
    
    migration_filename = MIGRATION_FILENAME[:payment_request]
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
            contact_id = row[1]
            description = row[2]
            code = row[3]
            no_bukti = row[4]
            exchange_id = row[5]
            account_payable_id = row[6]
            amount = row[7]
            exchange_rate_amount = row[8]
            requested_date = row[9]
            due_date = row[10]
            exchange_rate_id = row[11]
            is_confirmed = row[12]
            confirmation_date = row[13]
            is_deleted = row[14]
            
  
            is_deleted = get_truth_value( is_deleted )
            next if is_deleted  
            
 
            
            is_deleted = get_truth_value( is_confirmed )
             
              
            new_contact_id =  contact_mapping_hash[contact_id]
            new_exchange_id =  exchange_mapping_hash[exchange_id]
            new_account_id =  account_mapping_hash[account_payable_id]
            
            if new_contact_id.nil?
              puts "the  new_contact_id is nil, from old value: #{contact_id}"
              next 
            end    
            
            if new_exchange_id.nil?
              puts "the  new_exchange_id is nil, from old value: #{exchange_id}"
              next 
            end    
            
            if new_account_id.nil?
              puts "the  new_account_id is nil, from old value: #{account_id}"
              next 
            end    
     
            parsed_request_date = get_parsed_date(requested_date) 
            parsed_due_date = get_parsed_date(due_date) 
 
            object =  PaymentRequest.create_object(
                :contact_id =>  new_contact_id,
                :request_date => parsed_request_date,
                :due_date => parsed_due_date,
                :exchange_id => new_exchange_id,
                :account_id =>  new_account_id
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
    
    migration_filename = MIGRATION_FILENAME[:payment_request_confirm] 
    confirm_lookup_location =  lookup_file_location(  migration_filename ) 
    
    CSV.open(confirm_lookup_location, 'w') do |csv|
      confirm_result_array.each do |el| 
        csv <<  el 
      end
    end
    
    puts "Done migrating PaymentRequest. Total PaymentRequest: #{PaymentRequest.count}"
  end
  
   
  task :payment_request_detail => :environment do  

    payment_request_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:payment_request] )   
    account_mapping_hash =  get_mapping_hash(  MIGRATION_FILENAME[:coa] )
     
    
    migration_filename = MIGRATION_FILENAME[:payment_request_detail]
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
            payment_request_id = row[1]
            account_id = row[2]
            code = row[3]
            status = row[4]
            amount = row[5]
            is_legacy = row[6]
            is_confirmed = row[7]
            confirmation_date = row[8]
            is_deleted = row[9]
 
             
            is_deleted = get_truth_value(is_deleted )
            next if is_deleted  
            
   
            
 
              
            new_payment_request_id =  payment_request_mapping_hash[payment_request_id]
            new_account_id = account_mapping_hash[account_id]
            
            if new_payment_request_id.nil?
              puts "the new payment_requestid is nil, from old value: #{payment_request_id}"
              next 
            end
            
            if new_account_id.nil?
              puts "the new_account_id is nil, from old value: #{account_id}"
              next
            end
        
            if not [
              STATUS_ACCOUNT[:debet], 
              STATUS_ACCOUNT[:credit], 
              ].include?(status.to_i)
              puts "fark, wrong status account"
              next 
            end
        
            object = PaymentRequestDetail.create_object(
                :payment_request_id => new_payment_request_id,
                :account_id => new_account_id,
                :status => status,
                :amount => amount,
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
    

    puts "Done migrating PaymentRequestDetail. Total PaymentRequestDetail: #{PaymentRequestDetail.count}"
  end
  
  task :confirm_payment_request => :environment do 
    migration_filename = MIGRATION_FILENAME[:payment_request_confirm]  
    lookup_location =  lookup_file_location(  migration_filename ) 
    
    CSV.open(lookup_location, 'r') do |csv| 
      csv.each do |row|
        id = row[0]
        confirmation_date_string = row[2] 
        parsed_confirmation_date = get_parsed_date(confirmation_date_string)
        
        object  = PaymentRequest.find_by_id( id )
        
        object.confirm_object( :confirmed_at => parsed_confirmation_date  )  
        
        object.errors.messages.each {|x| puts "id: #{object.id}. Error: #{x}" } 
        
        
      end
    end
          
    puts "Total confirmed PaymentRequest: #{PaymentRequest.where(:is_confirmed => true).count}"
  end
 

end
