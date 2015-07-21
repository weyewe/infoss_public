module AccountingService
  class CreatePurchaseDownPaymentAllocationJournal
  def CreatePurchaseDownPaymentAllocationJournal.create_confirmation_journal(purchase_down_payment_allocation) 
    message = "Purchase Down Payment Allocation"
      ta = TransactionData.create_object({
        :transaction_datetime => purchase_down_payment_allocation.allocation_date,
        :description =>  message,
        :transaction_source_id => purchase_down_payment_allocation.id , 
        :transaction_source_type => purchase_down_payment_allocation.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:purchase_down_payment_allocation_journal],
        :is_contra_transaction => false 
      }, true )
    
    #      Debit AccountPayable, Credit Hutang Lain-Lain
#     Debit AccountPayable
    td = TransactionDataDetail.create_object(
      :transaction_data_id => ta.id,        
      :account_id          => purchase_down_payment_allocation.receivable.exchange.account_payable_id  ,
      :entry_case          => NORMAL_BALANCE[:debit]     ,
      :amount              => (purchase_down_payment_allocation.total_amount   * purchase_down_payment_allocation.receivable.exchange_rate_amount).round(2),
      :real_amount         => purchase_down_payment_allocation.total_amount,
      :exchange_id         => purchase_down_payment_allocation.receivable.exchange_id,
      :description => "Debit Account Receivable"
      )
#     Credit Hutang Lain-Lain
    td = TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:hutang_lainnya][:code]).id  ,
        :entry_case          => NORMAL_BALANCE[:credit]     ,
        :amount              => (purchase_down_payment_allocation.total_amount   * purchase_down_payment_allocation.receivable.exchange_rate_amount).round(2),
        :description         => "Credit Revenue"
        )
    ta.confirm
  end
    
  def CreatePurchaseDownPaymentAllocationJournal.undo_create_confirmation_journal(object)
    last_transaction_data = TransactionData.where(
      :transaction_source_id => object.id , 
      :transaction_source_type => object.class.to_s ,
      :code => TRANSACTION_DATA_CODE[:purchase_down_payment_allocation_journal],
      :is_contra_transaction => false
    ).order("id DESC").first 
    last_transaction_data.create_contra_and_confirm if not last_transaction_data.nil?
  end
    
  end
end