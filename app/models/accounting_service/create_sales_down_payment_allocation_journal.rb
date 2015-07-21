module AccountingService
  class CreateSalesDownPaymentAllocationJournal
  def CreateSalesDownPaymentAllocationJournal.create_confirmation_journal(sales_down_payment_allocation) 
    message = "SalesDownPaymentAllocation"
      ta = TransactionData.create_object({
        :transaction_datetime => sales_down_payment_allocation.allocation_date,
        :description =>  message,
        :transaction_source_id => sales_down_payment_allocation.id , 
        :transaction_source_type => sales_down_payment_allocation.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:sales_down_payment_allocation_journal],
        :is_contra_transaction => false 
      }, true )
    
    #      Credit AccountReceivable, Debit Hutang Lain-Lain
    
#     Credir AccountReceivable
    td = TransactionDataDetail.create_object(
      :transaction_data_id => ta.id,        
      :account_id          => sales_down_payment_allocation.payable.exchange.account_payable_id  ,
      :entry_case          => NORMAL_BALANCE[:credit]     ,
      :amount              => (sales_down_payment_allocation.total_amount   * sales_down_payment_allocation.payable.exchange_rate_amount).round(2),
      :real_amount         => sales_down_payment_allocation.total_amount,
      :exchange_id         => sales_down_payment_allocation.payable.exchange_id,
      :description => "Debit Account Receivable"
      )
#     Debit Hutang Lain-Lain
    td = TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:hutang_lainnya][:code]).id  ,
        :entry_case          => NORMAL_BALANCE[:debit]     ,
        :amount              => (sales_down_payment_allocation.total_amount   * sales_down_payment_allocation.payable.exchange_rate_amount).round(2),
        :description         => "Credit Revenue"
        )
    ta.confirm
  end
    
  def CreateSalesDownPaymentAllocationJournal.undo_create_confirmation_journal(object)
    last_transaction_data = TransactionData.where(
      :transaction_source_id => object.id , 
      :transaction_source_type => object.class.to_s ,
      :code => TRANSACTION_DATA_CODE[:sales_down_payment_allocation_journal],
      :is_contra_transaction => false
    ).order("id DESC").first 
    last_transaction_data.create_contra_and_confirm if not last_transaction_data.nil?
  end
    
  end
end