require 'rubygems'
require 'pg'
require 'active_record'
require 'csv'


namespace :migrate_zga do 
  
   
  task :payment_voucher => :environment do  

    warehouse_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:warehouse] )
    
    contact_mapping_hash =  get_mapping_hash(  MIGRATION_FILENAME[:contact] ) 
    cash_bank_mapping_hash =  get_mapping_hash(  MIGRATION_FILENAME[:cash_bank] ) 
     
    
    migration_filename = MIGRATION_FILENAME[:payment_voucher]
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
            payment_date = row[5]
            is_gbch = row[6]
            gbch_no = row[7]
            due_date = row[8]
            is_reconciled = row[9]
            reconciliation_date = row[10]
            rate_to_idr = row[11]
            total_amount = row[12]
            total_pph23 = row[13]
            total_pph21 = row[14]
            biaya_bank = row[15]
            pembulatan = row[16]
            status_pembulatan = row[17]
            is_confirmed = row[18]
            confirmation_date = row[19]
            is_deleted = row[20]
  
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
            parsed_payment_date = get_parsed_date(payment_date) 
 
            object =  PaymentVoucher.create_object(
              :no_bukti => no_bukti,
              :is_gbch => is_gbch,
              :gbch_no => gbch_no,
              :due_date => parsed_due_date,
              :pembulatan => pembulatan,
              :status_pembulatan => status_pembulatan,
              :biaya_bank => biaya_bank,
              :rate_to_idr => rate_to_idr,
              :payment_date => parsed_payment_date,
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
    
    migration_filename = MIGRATION_FILENAME[:payment_voucher_confirm] 
    confirm_lookup_location =  lookup_file_location(  migration_filename ) 
    
    CSV.open(confirm_lookup_location, 'w') do |csv|
      confirm_result_array.each do |el| 
        csv <<  el 
      end
    end
    
    puts "Done migrating PaymentVoucher. Total PaymentVoucher: #{PaymentVoucher.count}"
  end
  
   
  task :payment_voucher_detail => :environment do  

    payment_voucher_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:payment_voucher] )  
    payable_mapping_hash =  get_mapping_hash(  MIGRATION_FILENAME[:payable] )  
    
    
    
    migration_filename = MIGRATION_FILENAME[:payment_voucher_detail]
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
            payment_voucher_id = row[1]
            payable_id = row[2]
            code = row[3]
            rate = row[4]
            amount = row[5]
            amount_paid = row[6]
            pph_21 = row[7]
            pph_23 = row[8]
            description = row[9]
            is_confirmed = row[10]
            confirmation_date = row[11]
            is_deleted = row[12]
         
            is_deleted = get_truth_value( is_deleted ) 
            next if is_deleted  
            
   
              
            new_payment_voucher_id =  payment_voucher_mapping_hash[payment_voucher_id]
            new_payable_id = payable_mapping_hash[payable_id ]
            
            if new_payment_voucher_id.nil?
              puts "the new new_payment_voucher_id is nil, from old value: #{payment_voucher_id}"
              next 
            end
            
            if new_payable_id.nil?
              puts "the new_payable_id  is nil, from old value: #{payable_id}"
              next
            end
   
            object =   PaymentVoucherDetail.create_object(
                :payment_voucher_id =>  new_payment_voucher_id,
                :payable_id =>  new_payable_id,
                :amount =>  amount,
                :amount_paid => amount_paid,
                :pph_21 =>  pph_21,
                :pph_23 => pph_23,
                :rate =>  rate
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
    

    puts "Done migrating PaymentVoucherDetail. Total PaymentVoucherDetail: #{PaymentVoucherDetail.count}"
    
    
  end
  
  task :confirm_payment_voucher => :environment do 
    migration_filename = MIGRATION_FILENAME[:payment_voucher_confirm]  
    lookup_location =  lookup_file_location(  migration_filename ) 
    
    CSV.open(lookup_location, 'r') do |csv| 
      csv.each do |row|
        id = row[0]
        confirmation_date_string = row[2] 
        parsed_confirmation_date = get_parsed_date(confirmation_date_string)
        
        object  = PaymentVoucher.find_by_id( id )
        
        object.confirm_object( :confirmed_at => parsed_confirmation_date  )  
        
        object.errors.messages.each {|x| puts "id: #{object.id}. Error: #{x}" } 
        
      end
    end
          
    puts "Total confirmed PaymentVoucher: #{PaymentVoucher.where(:is_confirmed => true).count}"
  end
 

end
