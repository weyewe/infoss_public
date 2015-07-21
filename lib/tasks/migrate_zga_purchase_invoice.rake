require 'rubygems'
require 'pg'
require 'active_record'
require 'csv'


namespace :migrate_zga do 
  
   
  task :purchase_invoice => :environment do  

    purchase_receival_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:purchase_receival] ) 
     
  
    migration_filename = MIGRATION_FILENAME[:purchase_invoice]
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
            purchase_receival_id = row[1]
            description = row[2]
            code = row[3]
            nomor_surat = row[4]
            currency_id = row[5]
            exchange_rate_amount = row[6]
            exchange_rate_id = row[7]
            amount_payable = row[8]
            discount = row[9]
            is_taxable = row[10]
            tax = row[11]
            invoice_date = row[12]
            due_date = row[13]
            is_confirmed = row[14]
            confirmation_date = row[15]
            is_deleted = row[16]
            
            is_deleted = false
            is_deleted = true if row[16] == "True" 
            next if is_deleted  
            
            is_taxable = false
            is_taxable = true if row[10] == "True" 
            
            is_confirmed = false
            is_confirmed = true if row[14] == "True" 
             
              
            new_purchase_receival_id =  purchase_receival_mapping_hash[purchase_receival_id ] 
     
            parsed_invoice_date = get_parsed_date(invoice_date) 
            parsed_due_date = get_parsed_date(due_date) 
          
 
            object =   PurchaseInvoice.create_object(
              :purchase_receival_id =>  new_purchase_receival_id,
              :invoice_date =>  parsed_invoice_date,
              :nomor_surat => nomor_surat,
              :description => description,
              :due_date => parsed_due_date
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
    
    migration_filename = MIGRATION_FILENAME[:purchase_invoice_confirm] 
    confirm_lookup_location =  lookup_file_location(  migration_filename ) 
    
    CSV.open(confirm_lookup_location, 'w') do |csv|
      confirm_result_array.each do |el| 
        csv <<  el 
      end
    end
    
    puts "Done migrating PurchaseInvoice. Total PurchaseInvoice: #{PurchaseInvoice.count}"
  end
  
   
  task :purchase_invoice_detail => :environment do  

    purchase_invoice_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:purchase_invoice] )  
    purchase_receival_detail_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:purchase_receival_detail] )  
     
    
       
    
    migration_filename = MIGRATION_FILENAME[:purchase_invoice_detail]
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
            purchase_invoice_id = row[1]
            purchase_receival_detail_id = row[2]
            code = row[3]
            quantity = row[4]
            amount = row[5]
            is_confirmed = row[6]
            confirmation_date = row[7]
            is_deleted = row[8]
            
            is_deleted = false
            is_deleted = true if row[11] == "True" 
            next if is_deleted  
            
          
              
            new_purchase_invoice_id =  purchase_invoice_mapping_hash[purchase_invoice_id]
            new_purchase_receival_detail_id = purchase_receival_detail_mapping_hash[purchase_receival_detail_id]
            
            if new_purchase_invoice_id.nil?
              puts "the new new_purchase_invoice_id is nil, from old value: #{purchase_invoice_id}"
              next 
            end
            
            if new_purchase_receival_detail_id.nil?
              puts "the new_purchase_receival_detail_id is nil, from old value: #{purchase_receival_detail_id}"
              next
            end
   
            object = PurchaseInvoiceDetail.create_object(
              :purchase_invoice_id =>  new_purchase_invoice_id,
              :purchase_receival_detail_id => new_purchase_receival_detail_id,
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
    

    puts "Done migrating PurchaseInvoiceDetail. Total PurchaseInvoiceDetail: #{PurchaseInvoiceDetail.count}"
  end
  
  task :confirm_purchase_invoice => :environment do 
    migration_filename = MIGRATION_FILENAME[:purchase_invoice_confirm]  
    lookup_location =  lookup_file_location(  migration_filename ) 
    
    CSV.open(lookup_location, 'r') do |csv| 
      csv.each do |row|
        id = row[0]
        confirmation_date_string = row[2] 
        parsed_confirmation_date = get_parsed_date(confirmation_date_string)
        
        object  = PurchaseInvoice.find_by_id( id )
        
        object.confirm_object( :confirmed_at => parsed_confirmation_date  )  
        
        object.errors.messages.each {|x| puts "id: #{object.id}. Error: #{x}" } 
        
      end
    end
          
    puts "Total confirmed PurchaseInvoice: #{PurchaseInvoice.where(:is_confirmed => true).count}"
  end
 

end
