module AccountingService
  class CreateSalesDownPaymentJournal
  def CreateSalesDownPaymentJournal.create_confirmation_journal(sales_down_payment) 
    message = "SalesDownPayment"
      ta = TransactionData.create_object({
        :transaction_datetime => sales_down_payment.down_payment_date,
        :description =>  message,
        :transaction_source_id => sales_down_payment.id , 
        :transaction_source_type => sales_down_payment.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:sales_down_payment_journal],
        :is_contra_transaction => false 
      }, true )
    
    #      Debit AccountReceivable, Credit Hutang Lain-Lain
    
#     Debit AccountReceivable
    TransactionDataDetail.create_object(
      :transaction_data_id => ta.id,        
      :account_id          => sales_down_payment.exchange.account_receivable_id  ,
      :entry_case          => NORMAL_BALANCE[:debit]     ,
      :amount              => (sales_down_payment.total_amount   * sales_down_payment.exchange_rate_amount).round(2),
      :real_amount         => sales_down_payment.total_amount,
      :exchange_id         => sales_down_payment.exchange_id,
      :description => "Debit Account Receivable"
      )
#     Credit Hutang Lain-Lain
    TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:hutang_lainnya][:code]).id  ,
        :entry_case          => NORMAL_BALANCE[:credit]     ,
        :amount              => (sales_down_payment.total_amount   * sales_down_payment.exchange_rate_amount).round(2),
        :description         => "Credit Revenue"
        )
    ta.confirm
  end
    
  def CreateSalesDownPaymentJournal.undo_create_confirmation_journal(object)
    last_transaction_data = TransactionData.where(
      :transaction_source_id => object.id , 
      :transaction_source_type => object.class.to_s ,
      :code => TRANSACTION_DATA_CODE[:sales_down_payment_journal],
      :is_contra_transaction => false
    ).order("id DESC").first 
    last_transaction_data.create_contra_and_confirm if not last_transaction_data.nil?
  end
    
  end
end