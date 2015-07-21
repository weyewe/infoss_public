module AccountingService
  class CreatePurchaseDownPaymentJournal
  def CreatePurchaseDownPaymentJournal.create_confirmation_journal(purchase_down_payment) 
    message = "PurchaseDownPayment"
      ta = TransactionData.create_object({
        :transaction_datetime => purchase_down_payment.down_payment_date,
        :description =>  message,
        :transaction_source_id => purchase_down_payment.id , 
        :transaction_source_type => purchase_down_payment.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:purchase_down_payment_journal],
        :is_contra_transaction => false 
      }, true )
    
    #      Credit AccountPayable, Debit Hutang Lain-Lain
    
#     Credit AccountPayable
    TransactionDataDetail.create_object(
      :transaction_data_id => ta.id,        
      :account_id          => purchase_down_payment.exchange.account_payable_id  ,
      :entry_case          => NORMAL_BALANCE[:credit]     ,
      :amount              => (purchase_down_payment.total_amount   * purchase_down_payment.exchange_rate_amount).round(2),
      :real_amount         => purchase_down_payment.total_amount,
      :exchange_id         => purchase_down_payment.exchange_id,
      :description => "Credit Account Payable"
      )
#     Debit Hutang Lain-Lain
    TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:hutang_lainnya][:code]).id  ,
        :entry_case          => NORMAL_BALANCE[:debit]     ,
        :amount              => (purchase_down_payment.total_amount   * purchase_down_payment.exchange_rate_amount).round(2),
        :description         => "Debit Revenue"
        )
    ta.confirm
  end
    
  def CreatePurchaseDownPaymentJournal.undo_create_confirmation_journal(object)
    last_transaction_data = TransactionData.where(
      :transaction_source_id => object.id , 
      :transaction_source_type => object.class.to_s ,
      :code => TRANSACTION_DATA_CODE[:purchase_down_payment_journal],
      :is_contra_transaction => false
    ).order("id DESC").first 
    last_transaction_data.create_contra_and_confirm if not last_transaction_data.nil?
  end
    
  end
end