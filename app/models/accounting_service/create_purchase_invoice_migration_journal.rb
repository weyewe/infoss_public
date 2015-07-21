module AccountingService
  class CreatePurchaseInvoiceMigrationJournal
  def CreatePurchaseInvoiceMigrationJournal.create_confirmation_journal(purchase_invoice_migration) 
    message = "Purchase Invoice Migration"
      ta = TransactionData.create_object({
        :transaction_datetime => purchase_invoice_migration.invoice_date,
        :description =>  message,
        :transaction_source_id => purchase_invoice_migration.id , 
        :transaction_source_type => purchase_invoice_migration.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:purchase_invoice_migration_journal],
        :is_contra_transaction => false 
      }, true )
    
    #      Credit AccountPayable, Debit GoodsPendingClearance
#     Credit AccountPayable
    TransactionDataDetail.create_object(
      :transaction_data_id => ta.id,        
      :account_id          => purchase_invoice_migration.exchange.account_payable_id  ,
      :entry_case          => NORMAL_BALANCE[:credit]     ,
      :amount              => (purchase_invoice_migration.amount_payable   * purchase_invoice_migration.exchange_rate_amount).round(2),
      :real_amount         => purchase_invoice_migration.amount_payable,
      :exchange_id         => purchase_invoice_migration.exchange_id,
      :description => "Credit Account Payable"
      )
    
    TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:hutang_pembelian_lainnya][:code]).id  ,
        :entry_case          => NORMAL_BALANCE[:debit]     ,
        :amount              => (purchase_invoice_migration.amount_payable   * purchase_invoice_migration.exchange_rate_amount).round(2),
        :description         => "Debit GoodsPendingClearance"
        )
    ta.confirm
  end
    
  def CreatePurchaseInvoiceMigrationJournal.undo_create_confirmation_journal(object)
    last_transaction_data = TransactionData.where(
      :transaction_source_id => object.id , 
      :transaction_source_type => object.class.to_s ,
      :code => TRANSACTION_DATA_CODE[:purchase_invoice_migration_journal],
      :is_contra_transaction => false
    ).order("id DESC").first 
    last_transaction_data.create_contra_and_confirm if not last_transaction_data.nil?
  end
    
  end
end