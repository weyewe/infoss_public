require 'rubygems'
require 'pg'
require 'active_record'
require 'csv'


namespace :migrate_zga do 
  
   
  task :sales_invoice => :environment do  

    delivery_order_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:delivery_order] ) 
    
    puts  "do mapping_hash"
    puts delivery_order_mapping_hash
  
    migration_filename = MIGRATION_FILENAME[:sales_invoice]
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
            delivery_order_id = row[1]
            description = row[2]
            code = row[3]
            nomor_surat = row[4]
            currency_id = row[5]
            exchange_rate_amount = row[6]
            total_c_o_s = row[7]
            amount_receivable = row[8]
            discount = row[9]
            d_p_p = row[10]
            tax = row[11]
            exchange_rate_id = row[12]
            invoice_date = row[13]
            due_date = row[14]
            is_confirmed = row[15]
            confirmation_date = row[16]
            is_deleted = row[17]
            
            is_deleted = false
            is_deleted = true if row[17] == "True" 
            next if is_deleted  

            
            is_confirmed = false
            is_confirmed = true if row[15] == "True" 
             
              
            puts "The old do: #{delivery_order_id}"
            new_delivery_order_id =  delivery_order_mapping_hash[delivery_order_id  ] 
            puts ">>> new do: #{new_delivery_order_id}"
            
            if new_delivery_order_id.nil?
              puts "Fark, fail. The old id: #{delivery_order_id}"
              next
            end
     
            parsed_invoice_date = get_parsed_date(invoice_date) 
            parsed_due_date = get_parsed_date(due_date) 
          
            
            puts ">>>>>>> The delivery order id: #{new_delivery_order_id}"
            object =   SalesInvoice.create_object(
              :delivery_order_id => new_delivery_order_id,
              :invoice_date => parsed_invoice_date,
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
    
    migration_filename = MIGRATION_FILENAME[:sales_invoice_confirm] 
    confirm_lookup_location =  lookup_file_location(  migration_filename ) 
    
    CSV.open(confirm_lookup_location, 'w') do |csv|
      confirm_result_array.each do |el| 
        csv <<  el 
      end
    end
    
    puts "Done migrating SalesInvoice. Total SalesInvoice: #{SalesInvoice.count}"
  end
  
   
  task :sales_invoice_detail => :environment do  

    sales_invoice_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:sales_invoice] )  
    delivery_order_detail_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:delivery_order_detail] )  
     
     
    
    migration_filename = MIGRATION_FILENAME[:sales_invoice_detail]
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
            sales_invoice_id = row[1]
            delivery_order_detail_id = row[2]
            code = row[3]
            quantity = row[4]
            c_o_s = row[5]
            amount = row[6]
            is_confirmed = row[7]
            confirmation_date = row[8]
            is_deleted = row[9] 
            
            is_deleted = false
            is_deleted = true if row[9] == "True" 
            next if is_deleted  
            
          
              
            new_sales_invoice_id =  sales_invoice_mapping_hash[sales_invoice_id]
            new_delivery_order_detail_id = delivery_order_detail_mapping_hash[delivery_order_detail_id]
            
            if new_sales_invoice_id.nil?
              puts "the new new_sales_invoice_id is nil, from old value: #{sales_invoice_id}"
              next 
            end
            
            if new_delivery_order_detail_id.nil?
              puts "the new_delivery_order_detail_id is nil, from old value: #{delivery_order_detail_id}"
              next
            end
   
            object = SalesInvoiceDetail.create_object(
              :sales_invoice_id =>  new_sales_invoice_id ,
              :delivery_order_detail_id => new_delivery_order_detail_id ,
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
    

    puts "Done migrating SalesInvoiceDetail. Total SalesInvoiceDetail: #{SalesInvoiceDetail.count}"
  end
  
  task :confirm_sales_invoice => :environment do 
    migration_filename = MIGRATION_FILENAME[:sales_invoice_confirm]  
    lookup_location =  lookup_file_location(  migration_filename ) 
    
    CSV.open(lookup_location, 'r') do |csv| 
      csv.each do |row|
        id = row[0]
        confirmation_date_string = row[2] 
        parsed_confirmation_date = get_parsed_date(confirmation_date_string)
        
        object  = SalesInvoice.find_by_id( id )
        
        object.confirm_object( :confirmed_at => parsed_confirmation_date  )  
        
        object.errors.messages.each {|x| puts "id: #{object.id}. Error: #{x}" } 
        
      end
    end
          
    puts "Total confirmed SalesInvoice: #{SalesInvoice.where(:is_confirmed => true).count}"
  end
 

end
