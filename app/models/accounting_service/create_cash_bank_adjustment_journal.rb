module AccountingService
  class CreateCashBankAdjustmentJournal
  def CreateCashBankAdjustmentJournal.create_confirmation_journal(cash_bank_adjustment) 
      
    message = "CashBank Adjustment"

      ta = TransactionData.create_object({
        :transaction_datetime => cash_bank_adjustment.adjustment_date,
        :description =>  message,
        :transaction_source_id => cash_bank_adjustment.id , 
        :transaction_source_type => cash_bank_adjustment.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:cash_bank_adjustment_journal],
        :is_contra_transaction => false ,
      }, true )

      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => cash_bank_adjustment.cash_bank.account_id     ,
        :entry_case          => NORMAL_BALANCE[:debit]     ,
        :amount              => (cash_bank_adjustment.amount * cash_bank_adjustment.exchange_rate_amount).round(2) ,
        :real_amount         => cash_bank_adjustment.amount ,
        :exchange_id         => cash_bank_adjustment.cash_bank.exchange_id ,
        :description => "Debit CashBank"
      )

      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:penyesuaian_modal_level_3][:code]).id        ,
        :entry_case          => NORMAL_BALANCE[:credit]     ,
        :amount              => (cash_bank_adjustment.amount * cash_bank_adjustment.exchange_rate_amount).round(2),
        :description => "Credit Penyesuaian Modal"
      )
      ta.confirm
    end

    def CreateCashBankAdjustmentJournal.undo_create_confirmation_journal(object)
      last_transaction_data = TransactionData.where(
        :transaction_source_id => object.id , 
        :transaction_source_type => object.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:cash_bank_adjustment_journal],
        :is_contra_transaction => false
      ).order("id DESC").first 
      last_transaction_data.create_contra_and_confirm if not last_transaction_data.nil?
    end

  end
end