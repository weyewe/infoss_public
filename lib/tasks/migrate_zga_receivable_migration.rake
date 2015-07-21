require 'rubygems'
require 'pg'
require 'active_record'
require 'csv'


namespace :migrate_zga do 

 
  task :outstanding_sales_invoice => :environment do
    
    
    exchange_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:exchange] )  
    contact_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:contact] ) 
    
  
    
    migration_filename = MIGRATION_FILENAME[:outstanding_sales_invoice]
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
          amount_receivable = row[5]
          tax = row[6]
          dpp = row[7]
          invoice_date = row[8]
          is_deleted = false
          is_deleted = true if row[11] == "True"
          
          
          is_deleted = get_truth_value(is_deleted ) 
          next if is_deleted
          
          
          
          new_exchange_id = exchange_mapping_hash[exchange_id]
          new_contact_id = contact_mapping_hash[contact_id]
          parsed_invoice_date = get_parsed_date(invoice_date)
          
          
          object = SalesInvoiceMigration.create_object(
            :nomor_surat =>  nomor_surat,
            :contact_id =>  new_contact_id,
            :exchange_id => new_exchange_id,
            :amount_receivable =>  amount_receivable,
            :exchange_rate_amount => exchange_rate_amount,
            :tax => tax,
            :dpp =>  dpp,
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
    
    puts "Done migrating SalesInvoiceMigration. Total SalesInvoiceMigration: #{SalesInvoiceMigration.count}"
  end
  
  task :receivable => :environment do
    
    
    sales_invoice_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:sales_invoice] )  
    outstanding_sales_invoice_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:outstanding_sales_invoice] ) 
    
  
    
    migration_filename = MIGRATION_FILENAME[:receivable]
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
          receivable_source = row[2]
          receivable_source_id = row[3]
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
          created_at = row[14]
          updated_at = row[15]
          deleted_at = row[16]
          
          
          
       
       
       
          
          
          is_deleted = get_truth_value(is_deleted ) 
          next if is_deleted
          
          object = nil 
          
          
          if receivable_source == "SalesInvoice"
            new_sales_invoice_id = sales_invoice_mapping_hash[receivable_source_id]
            
            if new_sales_invoice_id.nil? 
              puts "fuck. new_sales_invoice_id is nil.. receivable_id : #{id}"
              next
            end
            
 
    
            object   = Receivable.where(
                :source_class => "SalesInvoice",
                :source_id => new_sales_invoice_id
              ).first 
              
              

            
          elsif receivable_source == "SalesInvoiceMigration"
            new_sales_invoice_migration_id = outstanding_sales_invoice_mapping_hash[receivable_source_id]
            
            if new_sales_invoice_migration_id.nil? 
              puts "fuck. new_sales_invoice_migration_id is nil.. receivable_id : #{id}"
              next
            end
            
            object   = Receivable.where(
                :source_class => "SalesInvoiceMigration",
                :source_id => new_sales_invoice_migration_id
              ).first 
              
            
          else
            puts "Fark, another source receivable. id: #{id}"
            next
          end
          
          
 

          if not object.nil? 
            lookup_counter = lookup_counter + 1 
            result_array << [ id ,    object.id    ] 
          end
          

        end
    end
    
    CSV.open(lookup_location, 'w') do |csv|
      result_array.each do |el| 
        csv <<  el 
      end
    end
    
    puts "Done migrating Receivable. Total Receivable: #{ lookup_counter}"
  end
end