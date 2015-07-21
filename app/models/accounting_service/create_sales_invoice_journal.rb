module AccountingService
  class CreateSalesInvoiceJournal
  def CreateSalesInvoiceJournal.create_confirmation_journal(sales_invoice) 
    message = "Sales Invoice"
      ta = TransactionData.create_object({
        :transaction_datetime => sales_invoice.invoice_date,
        :description =>  message,
        :transaction_source_id => sales_invoice.id , 
        :transaction_source_type => sales_invoice.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:sales_invoice_journal],
        :is_contra_transaction => false 
      }, true )
    
    #      Debit AccountReceivable, Debit Discount, Credit PPNKELUARAN, Credit Revenue
    pre_tax = sales_invoice.amount_receivable * 100 / (100 + sales_invoice.tax);
    tax = sales_invoice.amount_receivable - pre_tax;
    discount = pre_tax * sales_invoice.discount / 100;
    
#     Debit AccountReceivable
    TransactionDataDetail.create_object(
      :transaction_data_id => ta.id,        
      :account_id          => sales_invoice.exchange.account_receivable_id  ,
      :entry_case          => NORMAL_BALANCE[:debit]     ,
      :amount              => (sales_invoice.amount_receivable   * sales_invoice.exchange_rate_amount).round(2),
      :real_amount         => sales_invoice.amount_receivable,
      :exchange_id         => sales_invoice.exchange_id,
      :description => "Debit Account Receivable"
      )
    if sales_invoice.discount > 0 
#       Debit Discount
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:discount][:code]).id  ,
        :entry_case          => NORMAL_BALANCE[:debit]     ,
        :amount              => (sales_invoice.discount   * sales_invoice.exchange_rate_amount).round(2),
        :description => "Debit Discount"
        )
    end
    
    if tax > 0
#       Credit PPNkeluaran
      tax_amount = 0 
      if sales_invoice.delivery_order.sales_order.contact.is_taxable
        tax_amount = (tax * sales_invoice.exchange_rate_amount).round(2)
      else
        tax_amount =  ((sales_invoice.amount_receivable * sales_invoice.exchange_rate_amount) /11).round(2)
      end
     TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:ppn_keluaran][:code]).id  ,
       :entry_case          => NORMAL_BALANCE[:credit]     ,
        :amount              => tax_amount,
        :description => "Credit PPnkeluaran"
        )
    end
#     Credit Revenue
    amount_revenue = 0 
    if sales_invoice.delivery_order.sales_order.contact.is_taxable
      amount_revenue = (pre_tax * sales_invoice.exchange_rate_amount).round(2)
    else
      amount_revenue = (sales_invoice.dpp * sales_invoice.exchange_rate_amount * 10 /  11).round(2)
    end
    
    TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:pendapatan_penjualan_level_3][:code]).id  ,
        :entry_case          => NORMAL_BALANCE[:credit]     ,
        :amount              => amount_revenue,
        :description         => "Credit Revenue"
        )
#     Debit COS
    if sales_invoice.total_cos > 0 
    TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:harga_pokok_penjualan_level_3][:code]).id  ,
        :entry_case          => NORMAL_BALANCE[:debit]     ,
        :amount              => (sales_invoice.total_cos).round(2),
        :description         => "Debit COS"
        )
    end
    
#     Credit Inventory
    sales_invoice.sales_invoice_details.each do |sid|
      if sid.cos > 0 
        TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
          :account_id          => sid.delivery_order_detail.item.item_type.account_id ,
          :entry_case          => NORMAL_BALANCE[:credit]     ,
          :amount              => (sid.cos).round(2),
        :description => "Credit Inventory"
      )
      end
    end
    ta.confirm
  end
    
  def CreateSalesInvoiceJournal.undo_create_confirmation_journal(object)
    last_transaction_data = TransactionData.where(
      :transaction_source_id => object.id , 
      :transaction_source_type => object.class.to_s ,
      :code => TRANSACTION_DATA_CODE[:sales_invoice_journal],
      :is_contra_transaction => false
    ).order("id DESC").first 
    last_transaction_data.create_contra_and_confirm if not last_transaction_data.nil?
  end
    
  end
end