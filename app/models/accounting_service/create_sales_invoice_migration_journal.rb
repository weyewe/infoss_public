module AccountingService
  class CreateSalesInvoiceMigrationJournal
  def CreateSalesInvoiceMigrationJournal.create_confirmation_journal(sales_invoice_migration) 
    message = "Sales Invoice Migration"
      ta = TransactionData.create_object({
        :transaction_datetime => sales_invoice_migration.invoice_date,
        :description =>  message,
        :transaction_source_id => sales_invoice_migration.id , 
        :transaction_source_type => sales_invoice_migration.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:sales_invoice_migration_journal],
        :is_contra_transaction => false 
      }, true )
    
    #      Debit AccountReceivable, Debit Discount, Credit PPNKELUARAN, Credit Revenue
#     Debit AccountReceivable
    TransactionDataDetail.create_object(
      :transaction_data_id => ta.id,        
      :account_id          => sales_invoice_migration.exchange.account_receivable_id  ,
      :entry_case          => NORMAL_BALANCE[:debit]     ,
      :amount              => (sales_invoice_migration.amount_receivable   * sales_invoice_migration.exchange_rate_amount).round(2),
      :real_amount         => sales_invoice_migration.amount_receivable,
      :exchange_id         => sales_invoice_migration.exchange_id,
      :description => "Debit Account Receivable"
      )
    
    TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:pendapatan_penjualan_level_3][:code]).id  ,
        :entry_case          => NORMAL_BALANCE[:credit]     ,
        :amount              => (sales_invoice_migration.amount_receivable   * sales_invoice_migration.exchange_rate_amount).round(2),
        :description         => "Credit Revenue"
        )
    ta.confirm
  end
    
  def CreateSalesInvoiceMigrationJournal.undo_create_confirmation_journal(object)
    last_transaction_data = TransactionData.where(
      :transaction_source_id => object.id , 
      :transaction_source_type => object.class.to_s ,
      :code => TRANSACTION_DATA_CODE[:sales_invoice_migration_journal],
      :is_contra_transaction => false
    ).order("id DESC").first 
    last_transaction_data.create_contra_and_confirm if not last_transaction_data.nil?
  end
    
  end
end