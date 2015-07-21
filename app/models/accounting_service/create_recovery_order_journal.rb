module AccountingService
  class CreateRecoveryOrderJournal
    def CreateRecoveryOrderJournal.create_confirmation_journal(recovery_order_detail) 
      message = "RecoveryOrder"
        ta = TransactionData.create_object({
          :transaction_datetime => recovery_order_detail.finished_date,
          :description =>  message,
          :transaction_source_id => recovery_order_detail.id , 
          :transaction_source_type => recovery_order_detail.class.to_s ,
          :code => TRANSACTION_DATA_CODE[:recovery_order_journal],
          :is_contra_transaction => false 
        }, true )
  
      
  #    Credit Raw/Stock (Core, Compound, Accessories), Debit FinishedGoods/ManufacturedGoods (Roller)
      
      #    Credit Accessories
      if recovery_order_detail.accessories_cost > 0
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:bahan_baku_rollers][:code]).id    ,
        :entry_case          => NORMAL_BALANCE[:credit]     ,
        :amount              => (recovery_order_detail.accessories_cost).round(2),
        :description => "Credit Accessories"
        )
      end
  #     Credit Core
      if recovery_order_detail.core_cost > 0
          TransactionDataDetail.create_object(
            :transaction_data_id => ta.id,        
            :account_id          => Account.find_by_code(ACCOUNT_CODE[:bahan_baku_rollers][:code]).id   ,
            :entry_case          => NORMAL_BALANCE[:credit]     ,
            :amount              => (recovery_order_detail.core_cost).round(2),
            :description => "Credit Core"
          )
      end
      
      # Credit Compound
      TransactionDataDetail.create_object(
          :transaction_data_id => ta.id,        
          :account_id          => Account.find_by_code(ACCOUNT_CODE[:bahan_baku_rollers][:code]).id   ,
          :entry_case          => NORMAL_BALANCE[:credit]     ,
          :amount              => (recovery_order_detail.compound_cost).round(2),
          :description => "Credit Compound"
        )
      
      # Debit FinishedGoods
      TransactionDataDetail.create_object(
          :transaction_data_id => ta.id,        
          :account_id          => Account.find_by_code(ACCOUNT_CODE[:bahan_baku_rollers][:code]).id   ,
          :entry_case          => NORMAL_BALANCE[:credit]     ,
          :amount              => (recovery_order_detail.total_cost).round(2),
          :description => "Debit FinishedGoods"
        )
      
      ta.confirm
    end
    
    def CreateRecoveryOrderJournal.create_reject_journal(recovery_order_detail) 
      message = "RecoveryOrder"
        ta = TransactionData.create_object({
          :transaction_datetime => recovery_order_detail.rejected_date,
          :description =>  message,
          :transaction_source_id => recovery_order_detail.id , 
          :transaction_source_type => recovery_order_detail.class.to_s ,
          :code => TRANSACTION_DATA_CODE[:recovery_order_journal],
          :is_contra_transaction => false 
        }, true )
  
      
  #    Credit Raw/Stock (Core, Compound), Debit Recovery Expense (Roller)
      
      #     Debit  Recovery Expense
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:biaya_overhead_pabrik_level_3][:code]).id    ,
        :entry_case          => NORMAL_BALANCE[:debit]     ,
        :amount              => (recovery_order_detail.total_cost).round(2),
        :description => "Debit Recovery Expense"
        )
  
  #     Credit Core
      if recovery_order_detail.core_cost > 0
          TransactionDataDetail.create_object(
            :transaction_data_id => ta.id,        
            :account_id          => Account.find_by_code(ACCOUNT_CODE[:bahan_baku_rollers][:code]).id   ,
            :entry_case          => NORMAL_BALANCE[:credit]     ,
            :amount              => (recovery_order_detail.core_cost).round(2),
            :description => "Credit Core"
          )
      end
      
      # Credit Compound
      TransactionDataDetail.create_object(
          :transaction_data_id => ta.id,        
          :account_id          => Account.find_by_code(ACCOUNT_CODE[:bahan_baku_rollers][:code]).id   ,
          :entry_case          => NORMAL_BALANCE[:credit]     ,
          :amount              => (recovery_order_detail.compound_cost).round(2),
          :description => "Credit Compound"
        )
      ta.confirm
    end
  
    def CreateRecoveryOrderJournal.undo_create_confirmation_journal(object)
      last_transaction_data = TransactionData.where(
        :transaction_source_id => object.id , 
        :transaction_source_type => object.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:recovery_order_journal],
        :is_contra_transaction => false
      ).order("id DESC").first 
      last_transaction_data.create_contra_and_confirm if not last_transaction_data.nil?
    end
  end
end