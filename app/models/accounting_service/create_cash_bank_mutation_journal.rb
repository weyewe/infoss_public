module AccountingService
  class CreateCashBankMutationJournal
  def CreateCashBankMutationJournal.create_confirmation_journal(cash_bank_mutation) 
    message = "CashBank Mutation"
      ta = TransactionData.create_object({
        :transaction_datetime => cash_bank_mutation.mutation_date,
        :description =>  message,
        :transaction_source_id => cash_bank_mutation.id , 
        :transaction_source_type => cash_bank_mutation.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:cash_bank_mutation_journal],
        :is_contra_transaction => false 
      }, true )
    
#     debit target_cash_bank
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => cash_bank_mutation.target_cash_bank.account_id     ,
        :entry_case          => NORMAL_BALANCE[:debit]     ,
        :amount              => cash_bank_mutation.amount * cash_bank_mutation.exchange_rate_amount,
        :real_amount         => cash_bank_mutation.amount ,
        :exchange_id         => cash_bank_mutation.target_cash_bank.exchange_id ,
        :description => "Debit Target CashBank"
      )
    
#     credit source_cash_bank
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => cash_bank_mutation.source_cash_bank.account_id     ,
        :entry_case          => NORMAL_BALANCE[:credit]     ,
        :amount              => cash_bank_mutation.amount * cash_bank_mutation.exchange_rate_amount ,
        :real_amount         => cash_bank_mutation.amount ,
        :exchange_id         => cash_bank_mutation.source_cash_bank.exchange_id ,
        :description => "Credit Source CashBank"
      )
      ta.confirm
  end
    
  def CreateCashBankMutationJournal.undo_create_confirmation_journal(object)
    last_transaction_data = TransactionData.where(
      :transaction_source_id => object.id , 
      :transaction_source_type => object.class.to_s ,
      :code => TRANSACTION_DATA_CODE[:cash_bank_mutation_journal],
      :is_contra_transaction => false
    ).order("id DESC").first 
    last_transaction_data.create_contra_and_confirm if not last_transaction_data.nil?
  end
    
  end
end