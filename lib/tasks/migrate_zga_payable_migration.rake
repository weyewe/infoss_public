require 'rubygems'
require 'pg'
require 'active_record'
require 'csv'


namespace :migrate_zga do 

 
  task :outstanding_purchase_invoice => :environment do
    
    
    exchange_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:exchange] )  
    contact_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:contact] ) 
    
  
    
    migration_filename = MIGRATION_FILENAME[:outstanding_purchase_invoice]
    original_location =   original_file_location( migration_filename )
    lookup_location =  lookup_file_location(  migration_filename ) 
    
    result_array = [] 
    awesome_row_counter = - 1 
    
    CSV.open(original_location, 'r') do |csv| 
        csv.each do |row| 
          awesome_row_counter = awesome_row_counter + 1  
          next if awesome_row_counter == 0 
                    
          id = row[0]
          nomor_surat = row[1]
          contact_id = row[2]
          exchange_id = row[3]
          exchange_rate_amount = row[4]
          amount_payable = row[5]
          dpp = row[6]
          tax = row[7]
          invoice_date = row[8]
          is_deleted = row[9]
          
          
          is_deleted = get_truth_value(is_deleted ) 
          next if is_deleted
          
          
          
          new_exchange_id = exchange_mapping_hash[exchange_id]
          new_contact_id = contact_mapping_hash[contact_id]
          parsed_invoice_date = get_parsed_date(invoice_date)
          
          
          object = PurchaseInvoiceMigration.create_object(
              :nomor_surat => nomor_surat ,
              :contact_id => new_contact_id,
              :exchange_id =>  new_exchange_id,
              :amount_payable =>  amount_payable,
              :exchange_rate_amount =>  exchange_rate_amount ,
              :tax =>  tax,
              :dpp => dpp,
              :invoice_date =>  parsed_invoice_date
              )
            
          object.errors.messages.each {|x| puts "Error: #{x}" } 
          
           

          result_array << [ id , 
                    object.id  
                    ]
        end
    end
    
    CSV.open(lookup_location, 'w') do |csv|
      result_array.each do |el| 
        csv <<  el 
      end
    end
    
    puts "Done migrating PurchaseInvoiceMigration. Total PurchaseInvoiceMigration: #{PurchaseInvoiceMigration.count}"
  end
  
  task :payable => :environment do
    
    
    purchase_invoice_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:purchase_invoice] )  
    outstanding_purchase_invoice_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:outstanding_purchase_invoice] ) 
    payment_request_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:payment_request] ) 
    
   
    
    migration_filename = MIGRATION_FILENAME[:payable]
    original_location =   original_file_location( migration_filename )
    lookup_location =  lookup_file_location(  migration_filename ) 
    
    result_array = [] 
    awesome_row_counter = - 1 
    
    lookup_counter = 0 
    
    CSV.open(original_location, 'r') do |csv| 
        csv.each do |row| 
          awesome_row_counter = awesome_row_counter + 1  
          next if awesome_row_counter == 0 
                              
          id = row[0]
          contact_id = row[1]
          payable_source = row[2]
          payable_source_id = row[3]
          code = row[4]
          currency_id = row[5]
          rate = row[6]
          due_date = row[7]
          amount = row[8]
          remaining_amount = row[9]
          pending_clearance_amount = row[10]
          is_completed = row[11]
          completion_date = row[12]
          is_deleted = row[13]
          
          
          
        
          
          is_deleted = get_truth_value(is_deleted ) 
          next if is_deleted
          
          object = nil 
          
          
          if payable_source == "PurchaseInvoice"
            new_purchase_invoice_id = purchase_invoice_mapping_hash[payable_source_id]
            
            if new_purchase_invoice_id.nil? 
              puts "fuck. new_purchase_invoice_id is nil.. payable_id : #{id}"
              next
            end
            
 
    
            object   = Payable.where(
                :source_class => "PurchaseInvoice",
                :source_id => new_purchase_invoice_id
              ).first 
              
              
          elsif  payable_source == "PaymentRequest"
            new_payment_request_id = payment_request_mapping_hash[payable_source_id]
            
            if new_payment_request_id.nil? 
              puts "fuck. new_payment_request_id is nil.. payable_id : #{id}"
              next
            end
            
 
    
            object   = Payable.where(
                :source_class => "PaymentRequest",
                :source_id => new_payment_request_id
              ).first 
              
              

            
          elsif payable_source == "PurchaseInvoiceMigration"
            new_purchase_invoice_migration_id = outstanding_purchase_invoice_mapping_hash[payable_source_id]
            
            if new_purchase_invoice_migration_id.nil? 
              puts "fuck. new_purchase_invoice_migration_id is nil.. payable_id : #{id}"
              next
            end
            
            object   = Payable.where(
                :source_class => "PurchaseInvoiceMigration",
                :source_id => new_purchase_invoice_migration_id
              ).first 
              
            
          else
            puts "Fark, another source payable. id: #{id}"
            next
          end
          
          
 

          if not object.nil? 
            lookup_counter = lookup_counter + 1 
            result_array << [ id ,    object.id    ] 
          else
            puts "fark the object is nil!!!"
          end
          

        end
    end
    
    CSV.open(lookup_location, 'w') do |csv|
      result_array.each do |el| 
        csv <<  el 
      end
    end
    
    puts "Done migrating Payable. Total Payable: #{ lookup_counter}"
  end
end