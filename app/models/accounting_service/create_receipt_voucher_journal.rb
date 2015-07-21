module AccountingService
  class CreateReceiptVoucherJournal
  def CreateReceiptVoucherJournal.create_confirmation_journal(receipt_voucher) 
    message = "Receipt Voucher"
      ta = TransactionData.create_object({
        :transaction_datetime => receipt_voucher.receipt_date,
        :description =>  message,
        :transaction_source_id => receipt_voucher.id , 
        :transaction_source_type => receipt_voucher.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:receipt_voucher_journal],
        :is_contra_transaction => false 
      }, true )
    
    
#   GBCH: Debit GBCHReceivable, CashBank: DebitCashBank
#   Credit AccountReceivable, Credit ExchangeGain or Debit ExchangeLost


    if receipt_voucher.is_gbch == true
      #     debit GBCHReceivable
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => receipt_voucher.cash_bank.exchange.gbch_receivable_id  ,
        :entry_case          => NORMAL_BALANCE[:debit]     ,
        :amount              => (receipt_voucher.amount * receipt_voucher.rate_to_idr).round(2),
        :real_amount         => receipt_voucher.amount ,
        :exchange_id         => receipt_voucher.exchange_id ,
        :description => "Debit GBCHReceivable"
        )
      if receipt_voucher.biaya_bank > 0
#     Credit GBCH for biaya bank
        TransactionDataDetail.create_object(
          :transaction_data_id => ta.id,        
          :account_id          => receipt_voucher.cash_bank.exchange.gbch_receivable_id  ,
          :entry_case          => NORMAL_BALANCE[:credit]     ,
          :amount              => (receipt_voucher.biaya_bank * receipt_voucher.rate_to_idr).round(2),
          :real_amount         => receipt_voucher.biaya_bank ,
          :exchange_id         => receipt_voucher.exchange_id ,
          :description => "Credit GBCHReceivable for BiayaBank"
          )
      end
      
      #     Credit/Debit GBCH for Pembulatan
      if not receipt_voucher.pembulatan == 0
        entry_case = NORMAL_BALANCE[:credit]  
        if receipt_voucher.status_pembulatan == NORMAL_BALANCE[:credit]    
          entry_case =  NORMAL_BALANCE[:debit]
        end
        TransactionDataDetail.create_object(
          :transaction_data_id => ta.id,        
          :account_id          => receipt_voucher.cash_bank.exchange.gbch_receivable_id   ,
          :entry_case          => entry_case     ,
          :amount              => (receipt_voucher.pembulatan * receipt_voucher.rate_to_idr).round(2),
          :real_amount         => receipt_voucher.pembulatan ,
          :exchange_id         => receipt_voucher.exchange_id ,
          :description => "Credit/Debit GBCH for Pembulatan"
          ) 
      end
    else
      #       Debit CashBank
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => receipt_voucher.cash_bank.account_id  ,
        :entry_case          => NORMAL_BALANCE[:debit]     ,
        :amount              => (receipt_voucher.amount * receipt_voucher.rate_to_idr).round(2),
        :real_amount         => receipt_voucher.amount ,
        :exchange_id         => receipt_voucher.cash_bank.exchange_id ,
        :description => "Debit CashBank"
        )
      if receipt_voucher.biaya_bank > 0
#     Credit CashBank for biaya bank
        TransactionDataDetail.create_object(
          :transaction_data_id => ta.id,        
          :account_id          => receipt_voucher.cash_bank.account_id  ,
          :entry_case          => NORMAL_BALANCE[:credit]     ,
          :amount              => (receipt_voucher.biaya_bank * receipt_voucher.rate_to_idr).round(2),
          :real_amount         => receipt_voucher.biaya_bank ,
          :exchange_id         => receipt_voucher.cash_bank.exchange_id ,
          :description => "Credit CashBank for BiayaBank"
          )
      end
      
#     Credit/Debit CashBank for Pembulatan
      if not receipt_voucher.pembulatan == 0
        entry_case = NORMAL_BALANCE[:credit]  
        if receipt_voucher.status_pembulatan == NORMAL_BALANCE[:credit]    
          entry_case =  NORMAL_BALANCE[:debit]
        end
        TransactionDataDetail.create_object(
          :transaction_data_id => ta.id,        
          :account_id          => receipt_voucher.cash_bank.account_id  ,
          :entry_case          => entry_case     ,
          :amount              => (receipt_voucher.pembulatan * receipt_voucher.rate_to_idr).round(2),
          :real_amount         => receipt_voucher.pembulatan ,
          :exchange_id         => receipt_voucher.cash_bank.exchange_id ,
          :description         => "Credit/Debit CashBank for Pembulatan"
          ) 
      end
    end
    
#     Debit BiayaBank
    if receipt_voucher.biaya_bank > 0 
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:biaya_administrasi_bank][:code]).id   ,
        :entry_case          => NORMAL_BALANCE[:debit]      ,
        :amount              => (receipt_voucher.biaya_bank * receipt_voucher.rate_to_idr).round(2),
        :description => "Debit BiayaBank"
        ) 
    end
    
    #     Debit/Credit Pembulatan
    if receipt_voucher.biaya_bank > 0 
      
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:biaya_pembulatan][:code]).id   ,
        :entry_case          => receipt_voucher.status_pembulatan      ,
        :amount              => (receipt_voucher.pembulatan * receipt_voucher.rate_to_idr).round(2),
        :description => "Debit/Credit Pembulatan"
        ) 
    end    
    
    receipt_voucher.receipt_voucher_details.each do |rvd|
      #     Credit Account Receivable
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => rvd.receivable.exchange.account_receivable_id  ,
        :entry_case          => NORMAL_BALANCE[:credit]     ,
        :amount              => (rvd.amount * rvd.receivable.exchange_rate_amount).round(2),
        :real_amount         => rvd.amount ,
        :exchange_id         => rvd.receivable.exchange_id ,
        :description => "Credit AccountReceivable"
      )
#       Credit ExchangeGain or Debit ExchangeLost
      if rvd.receivable.exchange_rate_amount < receipt_voucher.rate_to_idr
        TransactionDataDetail.create_object(
          :transaction_data_id => ta.id,        
          :account_id          => Account.find_by_code(ACCOUNT_CODE[:pendapatan_selisih_kurs][:code]).id  ,
          :entry_case          => NORMAL_BALANCE[:credit]     ,
          :amount              => ((receipt_voucher.rate_to_idr * rvd.rate * rvd.amount) - (rvd.receivable.exchange_rate_amount * rvd.amount)).round(2),
          :description => "Credit ExchangeGain"
          )        
      elsif rvd.receivable.exchange_rate_amount > receipt_voucher.rate_to_idr
        TransactionDataDetail.create_object(
          :transaction_data_id => ta.id,        
          :account_id          => Account.find_by_code(ACCOUNT_CODE[:rugi_selisih_kurs][:code]).id  ,
          :entry_case          => NORMAL_BALANCE[:debit]     ,
          :amount              => ((rvd.receivable.exchange_rate_amount * rvd.amount) - (receipt_voucher.rate_to_idr * rvd.rate * rvd.amount)).round(2),
          :description => "Debit ExchangeLost"
          )   
      end
      
      if rvd.pph_23 > 0
        #         Debit Biaya PPh 23
        pph_23 = (receipt_voucher.rate_to_idr * rvd.pph_23).round(2)
        TransactionDataDetail.create_object(
          :transaction_data_id => ta.id,        
          :account_id          => Account.find_by_code(ACCOUNT_CODE[:pph_ps_23][:code]).id  ,
          :entry_case          => NORMAL_BALANCE[:debit]     ,
          :amount              => pph_23,
          :description => "Debit Biaya PPh 23"
          )  
        if receipt_voucher.is_gbch == true
          #           Credit GBCH for Biaya PPh 23
          TransactionDataDetail.create_object(
            :transaction_data_id => ta.id,        
            :account_id          => rvd.receivable.exchange.gbch_receivable_id   ,
            :entry_case          => NORMAL_BALANCE[:credit]     ,
            :amount              => pph_23,
            :description => "Credit GBCH for Biaya PPh 23"
            )  
        else
          #           Credit CashBank for Biaya PPh 23
          TransactionDataDetail.create_object(
            :transaction_data_id => ta.id,        
            :account_id          => receipt_voucher.cash_bank.account_id,
            :entry_case          => NORMAL_BALANCE[:credit]     ,
            :amount              => pph_23,
            :description => "Credit CashBank for Biaya PPh 23"
            )  
        end
      end
      
    end    
    ta.confirm
  end
    
    def CreateReceiptVoucherJournal.undo_create_confirmation_journal(object)
      last_transaction_data = TransactionData.where(
        :transaction_source_id => object.id , 
        :transaction_source_type => object.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:receipt_voucher_journal],
        :is_contra_transaction => false
      ).order("id DESC").first 
      last_transaction_data.create_contra_and_confirm if not last_transaction_data.nil?
    end
    
    def CreateReceiptVoucherJournal.create_reconcile_journal(receipt_voucher) 
      message = "Receipt Voucher"
        ta = TransactionData.create_object({
          :transaction_datetime => receipt_voucher.reconciliation_date,
          :description =>  message,
          :transaction_source_id => receipt_voucher.id , 
          :transaction_source_type => receipt_voucher.class.to_s ,
          :code => TRANSACTION_DATA_CODE[:receipt_voucher_journal],
          :is_contra_transaction => false 
        }, true )


      #      Debit CashBank, Credit GBCH
      biaya_pembulatan = 0 
      if receipt_voucher.status_pembulatan == NORMAL_BALANCE[:credit]
        biaya_pembulatan = receipt_voucher.pembulatan * -1
      else
        biaya_pembulatan = receipt_voucher.pembulatan
      end
      total = receipt_voucher.amount - (receipt_voucher.total_pph_23 + receipt_voucher.biaya_bank + biaya_pembulatan)
      #     Debit CashBank
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => receipt_voucher.cash_bank.account_id  ,
        :entry_case          => NORMAL_BALANCE[:debit]     ,
        :amount              => (total * receipt_voucher.rate_to_idr).round(2),
        :real_amount         => total ,
        :exchange_id         => receipt_voucher.cash_bank.exchange_id ,
        :description => message
        )

  #     Debit GBCH
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => receipt_voucher.cash_bank.exchange.gbch_receivable_id ,
        :entry_case          => NORMAL_BALANCE[:credit]     ,
        :amount              => (total * receipt_voucher.rate_to_idr).round(2),
        :real_amount         => total ,
        :exchange_id         => receipt_voucher.cash_bank.exchange_id ,
        :description => message
        )
      ta.confirm
    end
    
    def CreateReceiptVoucherJournal.undo_create_reconcile_journal(object)
      last_transaction_data = TransactionData.where(
        :transaction_source_id => object.id , 
        :transaction_source_type => object.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:receipt_voucher_journal],
        :is_contra_transaction => false
      ).order("id DESC").first 
      last_transaction_data.create_contra_and_confirm if not last_transaction_data.nil?
    end
    
  end
end