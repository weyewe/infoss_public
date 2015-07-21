module AccountingService
  class CreateBlanketOrderJournal
    # def CreateBlanketOrderJournal.create_finish_journal(blanket_order_detail) 
    #   message = "BlanketOrder FINISH"
    #     ta = TransactionData.create_object({
    #       :transaction_datetime => blanket_order_detail.finished_at,
    #       :description =>  message,
    #       :transaction_source_id => blanket_order_detail.id , 
    #       :transaction_source_type => blanket_order_detail.class.to_s ,
    #       :code => TRANSACTION_DATA_CODE[:blanket_order_detail_journal_finish],
    #       :is_contra_transaction => false 
    #     }, true )
  
        
    #   # for the finished case 
    #   total_finished_cost  =  (blanket_order_detail.total_cost * blanket_order_detail.finished_quantity_ratio  ).round(2)
    #   finished_roll_blanket_cost  =  (blanket_order_detail.manufacturing_used_roll_blanket_cost * blanket_order_detail.finished_quantity_ratio    ).round(2)
    #   finished_bar_cost = total_finished_cost - finished_roll_blanket_cost - finished_adhesive_cost
      
    #   # for the reject case
    #   total_rejected_cost =  blanket_order_detail.total_cost  - total_finished_cost
    #   rejected_roll_blanket_cost = blanket_order_detail.manufacturing_used_roll_blanket_cost  - finished_roll_blanket_cost
    #   rejected_bar_cost = total_rejected_cost - rejected_roll_blanket_cost
      
    #   # for the defect case 
    #   blanket_defect_cost = blanket_order_detail.roll_blanket_defect_cost
      
    #   if blanket_order_detail.finished_quantity > 0 
        
    #     TransactionDataDetail.create_object(
    #       :transaction_data_id => ta.id,        
    #       :account_id          => Account.find_by_code(ACCOUNT_CODE[:persediaan_printing_blanket][:code]).id     ,
    #       :entry_case          => NORMAL_BALANCE[:debit]     ,
    #       :amount              =>  total_finished_cost,
    #       :description => "Penambahan Persediaan Blanket hasil manufacturing"
    #       )
    
    # #     Credit Raw
    #     TransactionDataDetail.create_object(
    #       :transaction_data_id => ta.id,        
    #       :account_id          => Account.find_by_code(ACCOUNT_CODE[:bahan_baku_blanket][:code]).id  ,
    #       :entry_case          => NORMAL_BALANCE[:credit]     ,
    #       :amount              => finished_roll_blanket_cost,
    #       :description => "Penggunaan roll blanket untuk manufacturing"
    #       )
      
        
    #     if blanket_order_detail.bar_cost > 0 
    #       TransactionDataDetail.create_object(
    #       :transaction_data_id => ta.id,        
    #       :account_id          => Account.find_by_code(ACCOUNT_CODE[:bahan_baku_blanket][:code]).id  ,
    #       :entry_case          => NORMAL_BALANCE[:credit]     ,
    #       :amount              => finished_bar_cost,
    #       :description => "Penggunaan bar untuk manufacturing blanket"
    #       )
    #     end
    #   end
      
    #   if blanket_order_detail.rejected_quantity > 0 
          
    #     TransactionDataDetail.create_object(
    #       :transaction_data_id => ta.id,        
    #       :account_id          => Account.find_by_code(ACCOUNT_CODE[:biaya_overhead_pabrik_level_3][:code]).id     ,
    #       :entry_case          => NORMAL_BALANCE[:debit]     ,
    #       :amount              => total_rejected_cost,
    #       :description => "Biaya Overhead pabrik untuk manufacturing blanket REJECT"
    #       )
    
    # #     Credit Raw
    #     TransactionDataDetail.create_object(
    #       :transaction_data_id => ta.id,        
    #       :account_id          => Account.find_by_code(ACCOUNT_CODE[:bahan_baku_blanket][:code]).id  ,
    #       :entry_case          => NORMAL_BALANCE[:credit]     ,
    #       :amount              => rejected_roll_blanket_cost,
    #       :description => "Penggunaan Blanket untuk manufacturing blanket REJECT"
    #       )
          
    #     if blanket_order_detail.adhesive_cost > 0
    #       TransactionDataDetail.create_object(
    #       :transaction_data_id => ta.id,        
    #       :account_id          => Account.find_by_code(ACCOUNT_CODE[:bahan_baku_blanket][:code]).id ,
    #       :entry_case          => NORMAL_BALANCE[:credit]     ,
    #       :amount              => adhesive_cost,
    #       :description => "Penggunaan Adhesive untuk manufacturing blanket REJECT"
    #       )
    #     end
    #     if blanket_order_detail.bar_cost > 0 
    #       TransactionDataDetail.create_object(
    #       :transaction_data_id => ta.id,        
    #       :account_id          => Account.find_by_code(ACCOUNT_CODE[:bahan_baku_blanket][:code]).id  ,
    #       :entry_case          => NORMAL_BALANCE[:credit]     ,
    #       :amount              => rejected_bar_cost,
    #       :description => "Penggunaan bar untuk manufacturing blanket REJECT"
    #       )
    #     end
    #   end
      
    #   if blanket_order_detail.roll_blanket_defect_cost > BigDecimal("0")
    #     TransactionDataDetail.create_object(
    #       :transaction_data_id => ta.id,        
    #       :account_id          => Account.find_by_code(ACCOUNT_CODE[:biaya_overhead_pabrik_level_3][:code]).id     ,
    #       :entry_case          => NORMAL_BALANCE[:debit]     ,
    #       :amount              => blanket_defect_cost,
    #       :description => "Roll Blanket Defect"
    #       )
    
    # #     Credit Raw
    #     TransactionDataDetail.create_object(
    #       :transaction_data_id => ta.id,        
    #       :account_id          => Account.find_by_code(ACCOUNT_CODE[:bahan_baku_blanket][:code]).id  ,
    #       :entry_case          => NORMAL_BALANCE[:credit]     ,
    #       :amount              => blanket_defect_cost,
    #       :description => "Roll Blanket Defect"
    #       )
    #   end
      
    #   ta.confirm
    # end
    
    
    def CreateBlanketOrderJournal.create_finish_journal(blanket_order_detail) 
      message = "[BlanketOrder FINISH] finish: #{blanket_order_detail.finished_quantity} " + 
                    "|  reject: #{blanket_order_detail.rejected_quantity} " + 
                    " | defect: #{blanket_order_detail.roll_blanket_defect} m2"
        ta = TransactionData.create_object({
          :transaction_datetime => blanket_order_detail.finished_at,
          :description =>  message,
          :transaction_source_id => blanket_order_detail.id , 
          :transaction_source_type => blanket_order_detail.class.to_s ,
          :code => TRANSACTION_DATA_CODE[:blanket_order_detail_journal_finish],
          :is_contra_transaction => false 
        }, true )
  
        
      # for the finished case 
      total_finished_cost  =  (blanket_order_detail.total_cost * blanket_order_detail.finished_quantity_ratio  ).round(2)
      finished_roll_blanket_cost  =  (blanket_order_detail.manufacturing_used_roll_blanket_cost * blanket_order_detail.finished_quantity_ratio    ).round(2)
      finished_bar_cost = total_finished_cost - finished_roll_blanket_cost  
      
      # for the reject case
      total_rejected_cost =  blanket_order_detail.total_cost  - total_finished_cost
      rejected_roll_blanket_cost = blanket_order_detail.manufacturing_used_roll_blanket_cost  - finished_roll_blanket_cost
      rejected_bar_cost = total_rejected_cost - rejected_roll_blanket_cost
      
      # for the defect case 
      blanket_defect_cost = blanket_order_detail.roll_blanket_defect_cost
      
      persediaan_printing_blanket_amount = total_finished_cost 
      bahan_baku_blanket_cost = blanket_order_detail.total_cost  + blanket_order_detail.roll_blanket_defect_cost # defect + finish + reject 
      overhead_cost = bahan_baku_blanket_cost  - persediaan_printing_blanket_amount
      
   
        
        TransactionDataDetail.create_object(
          :transaction_data_id => ta.id,        
          :account_id          => Account.find_by_code(ACCOUNT_CODE[:persediaan_printing_blanket][:code]).id     ,
          :entry_case          => NORMAL_BALANCE[:debit]     ,
          :amount              =>  persediaan_printing_blanket_amount,
          :description => "Penambahan Persediaan Blanket hasil manufacturing"
          )
    
        TransactionDataDetail.create_object(
          :transaction_data_id => ta.id,        
          :account_id          => Account.find_by_code(ACCOUNT_CODE[:biaya_overhead_pabrik_level_3][:code]).id     ,
          :entry_case          => NORMAL_BALANCE[:debit]     ,
          :amount              => overhead_cost,
          :description => "Biaya Overhead pabrik untuk manufacturing blanket REJECT"
          )
    #     Credit Raw
        TransactionDataDetail.create_object(
          :transaction_data_id => ta.id,        
          :account_id          => Account.find_by_code(ACCOUNT_CODE[:bahan_baku_blanket][:code]).id  ,
          :entry_case          => NORMAL_BALANCE[:credit]     ,
          :amount              => bahan_baku_blanket_cost   ,
          :description => "Penggunaan roll blanket, adhesive, bar untuk manufacturing"
          )
      
    
      
      
      ta.confirm
    end
     
    
    def CreateBlanketOrderJournal.undo_create_confirmation_journal(object)
      last_transaction_data = TransactionData.where(
        :transaction_source_id => object.id , 
        :transaction_source_type => object.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:blanket_order_detail_journal],
        :is_contra_transaction => false
      ).order("id DESC").first 
      last_transaction_data.create_contra_and_confirm if not last_transaction_data.nil?
    end
    
  end
end