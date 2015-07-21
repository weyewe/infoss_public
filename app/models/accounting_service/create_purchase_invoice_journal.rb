module AccountingService
  class CreatePurchaseInvoiceJournal
  def CreatePurchaseInvoiceJournal.create_confirmation_journal(purchase_invoice) 
    message = "Purchase Invoice"
      ta = TransactionData.create_object({
        :transaction_datetime => purchase_invoice.invoice_date,
        :description =>  message,
        :transaction_source_id => purchase_invoice.id , 
        :transaction_source_type => purchase_invoice.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:purchase_invoice_journal],
        :is_contra_transaction => false 
      }, true )
#     debit raw
    pre_tax = purchase_invoice.amount_payable * 100 / (100 + purchase_invoice.tax);
    tax = purchase_invoice.amount_payable - pre_tax;
    discount = pre_tax * purchase_invoice.discount / 100;
    
#     Debit GoodsPendingClearance, Credit AccountPayable
#     Debit PPNMASUKAN, Debit ExchangeLoss or Credit ExchangeGain
    
#     Credit AccountPayable
    TransactionDataDetail.create_object(
      :transaction_data_id => ta.id,        
      :account_id          => purchase_invoice.exchange.account_payable_id  ,
      :entry_case          => NORMAL_BALANCE[:credit]     ,
      :amount              => (purchase_invoice.amount_payable * purchase_invoice.exchange_rate_amount).round(2),
      :real_amount         => purchase_invoice.amount_payable ,
      :exchange_id         => purchase_invoice.exchange_id ,
      :description => "Credit Account Payable"
      )

#     Debit GoodsPendingClearance
    purchase_invoice.purchase_invoice_details.each do |pid|
      detail_discount = pid.price * purchase_invoice.discount / 100
      detail_amount = pid.price - detail_discount
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => pid.purchase_receival_detail.item.item_type.account_id  ,
        :entry_case          => NORMAL_BALANCE[:debit]     ,
        :amount              => (detail_amount * purchase_invoice.exchange_rate_amount).round(2),
        :description => "Debit GoodsPendingClearance"
      )
    end
    
#     Debit PPN masukan    
    if tax  > 0 
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:ppn_masukan][:code]).id     ,
        :entry_case          => NORMAL_BALANCE[:debit]     ,
        :amount              => (tax * purchase_invoice.exchange_rate_amount).round(2) ,
        :description => "Debit PPN Masukan"
        )
    end
    
# #  Debit ExchangeLoss or Credit ExchangeGain
#     if purchase_invoice.exchange_rate_amount < purchase_invoice.purchase_receival.exchange_rate_amount
# #       Debit ExchangeLoss
#       TransactionDataDetail.create_object(
#         :transaction_data_id => ta.id,        
#         :account_id          => Account.find_by_code(ACCOUNT_CODE[:rugi_selish_kurs][:code]).id     ,
#         :entry_case          => NORMAL_BALANCE[:debit]     ,
#         :amount              => (pre_tax * purchase_invoice.exchange_rate_amount) - (pre_tax * purchase_invoice.purchase_receival.exchange_rate_amount) ,
#         :description => message
#         )
#     else
# #       Credit ExchangeGain
#       TransactionDataDetail.create_object(
#         :transaction_data_id => ta.id,        
#         :account_id          => Account.find_by_code(ACCOUNT_CODE[:pendapatan_selisih_kurs][:code]).id     ,
#         :entry_case          => NORMAL_BALANCE[:credit]     ,
#         :amount              => (pre_tax * purchase_invoice.purchase_receival.exchange_rate_amount) - (pre_tax * purchase_invoice.exchange_rate_amount),
#         :description => message
#         )
#     end
    ta.confirm
    end
    
    def CreatePurchaseInvoiceJournal.undo_create_confirmation_journal(object)
      last_transaction_data = TransactionData.where(
        :transaction_source_id => object.id , 
        :transaction_source_type => object.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:purchase_invoice_journal],
        :is_contra_transaction => false
      ).order("id DESC").first 
      last_transaction_data.create_contra_and_confirm if not last_transaction_data.nil?
    end
  end
end