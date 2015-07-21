require 'rubygems'
require 'pg'
require 'active_record'
require 'csv'


namespace :migrate_zga do 
  
   
  task :receipt_voucher => :environment do  

    warehouse_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:warehouse] )
    
    contact_mapping_hash =  get_mapping_hash(  MIGRATION_FILENAME[:contact] ) 
    cash_bank_mapping_hash =  get_mapping_hash(  MIGRATION_FILENAME[:cash_bank] ) 
     
    
    migration_filename = MIGRATION_FILENAME[:receipt_voucher]
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
            cash_bank_id = row[2]
            code = row[3]
            no_bukti = row[4]
            receipt_date = row[5]
            rate_to_idr = row[6]
            is_gbch = row[7]
            gbch_no = row[8]
            due_date = row[9]
            is_reconciled = row[10]
            reconciliation_date = row[11]
            total_amount = row[12]
            total_pph23 = row[13]
            biaya_bank = row[14]
            pembulatan = row[15]
            status_pembulatan = row[16]  # 1 atau 2 NORMAL_BALANCE[:credit] or debet
            is_confirmed = row[17]
            confirmation_date = row[18]
            is_deleted = row[19]
  
            is_deleted = get_truth_value( is_deleted ) 
            next if is_deleted  
            
            
        
            if not status_pembulatan.present?
              puts "wheee.. status_pembulatan tidak ada. id : #{id}"
            end
            
            if not [
                NORMAL_BALANCE[:debit],
                NORMAL_BALANCE[:credit]
              ].include?( status_pembulatan.to_i )
              puts "status_pembulatan present. tp tidak benar. id: #{id}"
            end
 
            is_confirmed = get_truth_value( is_confirmed )
            is_gbch = get_truth_value( is_gbch )
 
              
            new_contact_id =  contact_mapping_hash[contact_id]
            new_cash_bank_id =  cash_bank_mapping_hash[cash_bank_id] 
     
            parsed_due_date = get_parsed_date(due_date) 
            parsed_receipt_date = get_parsed_date(receipt_date) 
 
            object =  ReceiptVoucher.create_object(
              :no_bukti => no_bukti ,
              :is_gbch => is_gbch,
              :gbch_no => gbch_no,
              :due_date => parsed_due_date,
              :pembulatan => pembulatan,
              :status_pembulatan => status_pembulatan,
              :biaya_bank => biaya_bank ,
              :rate_to_idr => rate_to_idr,
              :receipt_date => parsed_receipt_date,
              :contact_id =>  new_contact_id,
              :cash_bank_id => new_cash_bank_id
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
    
    migration_filename = MIGRATION_FILENAME[:receipt_voucher_confirm] 
    confirm_lookup_location =  lookup_file_location(  migration_filename ) 
    
    CSV.open(confirm_lookup_location, 'w') do |csv|
      confirm_result_array.each do |el| 
        csv <<  el 
      end
    end
    
    puts "Done migrating ReceiptVoucher. Total ReceiptVoucher: #{ReceiptVoucher.count}"
  end
  
   
  task :receipt_voucher_detail => :environment do  

    receipt_voucher_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:receipt_voucher] )  
    receivable_mapping_hash =  get_mapping_hash(  MIGRATION_FILENAME[:receivable] )  
    
    
    
    migration_filename = MIGRATION_FILENAME[:receipt_voucher_detail]
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
            receipt_voucher_id = row[1]
            receivable_id = row[2]
            code = row[3]
            rate = row[4]
            amount = row[5]
            amount_paid = row[6]
            pph_23 = row[7]
            description = row[8]
            is_confirmed = row[9]
            confirmation_date = row[10]
            is_deleted = row[11]
            
            is_deleted = false
            is_deleted = true if row[10] == "True" 
            next if is_deleted  
            
   
              
            new_receipt_voucher_id =  receipt_voucher_mapping_hash[receipt_voucher_id]
            new_receivable_id = receivable_mapping_hash[receivable_id ]
            
            if new_receipt_voucher_id.nil?
              puts "the new new_receipt_voucher_id is nil, from old value: #{receipt_voucher_id}"
              next 
            end
            
            if new_receivable_id.nil?
              puts "the new_receivable_id  is nil, from old value: #{receivable_id}"
              next
            end
   
            object =   ReceiptVoucherDetail.create_object(
                  :receipt_voucher_id =>  new_receipt_voucher_id,
                  :receivable_id =>  new_receivable_id,
                  :amount =>  amount ,
                  :amount_paid =>  amount_paid,
                  :pph_23 =>  pph_23,
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
    

    puts "Done migrating ReceiptVoucherDetail. Total ReceiptVoucherDetail: #{ReceiptVoucherDetail.count}"
    
    
  end
  
  task :confirm_receipt_voucher => :environment do 
    migration_filename = MIGRATION_FILENAME[:receipt_voucher_confirm]  
    lookup_location =  lookup_file_location(  migration_filename ) 
    
    CSV.open(lookup_location, 'r') do |csv| 
      csv.each do |row|
        id = row[0]
        confirmation_date_string = row[2] 
        parsed_confirmation_date = get_parsed_date(confirmation_date_string)
        
        object  = ReceiptVoucher.find_by_id( id )
        
        object.confirm_object( :confirmed_at => parsed_confirmation_date  )  
        
        object.errors.messages.each {|x| puts "id: #{object.id}. Error: #{x}" } 
        
      end
    end
          
    puts "Total confirmed ReceiptVoucher: #{ReceiptVoucher.where(:is_confirmed => true).count}"
  end
 

end
