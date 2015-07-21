module AccountingService
  class CreateExchangeGainLossJournal
    
    def CreateExchangeGainLossJournal.create_master_transaction_journal(params)
      message = "Exchange Gain Loss Closing"
      ta = TransactionData.create_object({
          :transaction_datetime => params[:transaction_datetime],
          :description =>  message,
          :transaction_source_id => params[:transaction_source_id] , 
          :transaction_source_type => params[:transaction_source_type] ,
          :code => TRANSACTION_DATA_CODE[:closing],
          :is_contra_transaction => false ,
          }, true )
      return ta
    end
    
    def CreateExchangeGainLossJournal.create_exchange_gain_loss_cash_bank_journal(params) 
        if not  params[:valid_comb_amount] ==  params[:valid_comb_amount_non_idr ]
          ta = TransactionData.where(
            :id => transaction_data_id
          ).first 
          if (closing.valid_comb_amount > closing.valid_comb_amount_non_idr)
            # Credit CashBank Debit ExchangeLoss
             TransactionDataDetail.create_object(
            :transaction_data_id => ta.id,        
            :account_id          => params[:account_id]   ,
            :entry_case          => NORMAL_BALANCE[:credit]     ,
            :amount              => (params[:valid_comb_amount] - params[:valid_comb_amount_non_idr]).round(2) ,
            :description => "Credit CashBank"
            )
    
          TransactionDataDetail.create_object(
            :transaction_data_id => ta.id,        
            :account_id          => Account.find_by_code(ACCOUNT_CODE[:rugi_selisih_kurs][:code]).id        ,
            :entry_case          => NORMAL_BALANCE[:debit]     ,
            :amount              => (params[:valid_comb_amount] - params[:valid_comb_amount_non_idr]).round(2),
            :description => "Debit ExchangeGain"
            )
          end
          
          if (closing.valid_comb_amount < closing.valid_comb_amount_non_idr)
            # Debit CashBank Credit ExchangeGain
            TransactionDataDetail.create_object(
            :transaction_data_id => ta.id,        
            :account_id          => params[:account_id]     ,
            :entry_case          => NORMAL_BALANCE[:debit]     ,
            :amount              => (params[:valid_comb_amount_non_idr] - params[:valid_comb_amount]).round(2) ,
            :description => "Credit CashBank"
            )
    
            TransactionDataDetail.create_object(
            :transaction_data_id => ta.id,        
            :account_id          => Account.find_by_code(ACCOUNT_CODE[:pendapatan_selisih_kurs][:code]).id        ,
            :entry_case          => NORMAL_BALANCE[:credit]     ,
            :amount              => (params[:valid_comb_amount_non_idr] - params[:valid_comb_amount]).round(2) ,
            :description => "Debit ExchangeGain"
            )
            
          end
        end
    end
    
    def CreateExchangeGainLossJournal.create_exchange_gain_loss_account_payable_journal(params) 
      message = "Exchange Gain Loss Closing"
        if not  params[:valid_comb_amount] ==  params[:valid_comb_amount_non_idr ]
          ta = TransactionData.where(
            :id => transaction_data_id
          ).first 
        
          if (closing.valid_comb_amount > closing.valid_comb_amount_non_idr)
            # Debit AccountPayable Credit ExchangeGain
             TransactionDataDetail.create_object(
            :transaction_data_id => ta.id,        
            :account_id          => params[:account_id]   ,
            :entry_case          => NORMAL_BALANCE[:debit]     ,
            :amount              => (params[:valid_comb_amount] - params[:valid_comb_amount_non_idr]).round(2) ,
            :description => "Debit AccountPayable"
            )
    
          TransactionDataDetail.create_object(
            :transaction_data_id => ta.id,        
            :account_id          => Account.find_by_code(ACCOUNT_CODE[:pendapatan_selisih_kurs][:code]).id        ,
            :entry_case          => NORMAL_BALANCE[:credit]     ,
            :amount              => (params[:valid_comb_amount] - params[:valid_comb_amount_non_idr]).round(2),
            :description => "Credit ExchangeGain"
            )
          end
          
          if (closing.valid_comb_amount < closing.valid_comb_amount_non_idr)
            # Credit AccountPayable Debit ExchangeLoss
            TransactionDataDetail.create_object(
            :transaction_data_id => ta.id,        
            :account_id          => params[:account_id]     ,
            :entry_case          => NORMAL_BALANCE[:credit]     ,
            :amount              => (params[:valid_comb_amount_non_idr] - params[:valid_comb_amount]).round(2) ,
            :description => "Credit AccountPayable"
            )
    
            TransactionDataDetail.create_object(
            :transaction_data_id => ta.id,        
            :account_id          => Account.find_by_code(ACCOUNT_CODE[:pendapatan_selisih_kurs][:code]).id        ,
            :entry_case          => NORMAL_BALANCE[:credit]     ,
            :amount              => (params[:valid_comb_amount_non_idr] - params[:valid_comb_amount]).round(2) ,
            :description => "Debit ExchangeLoss"
            )
            
          end
        end
    end
    
    def CreateExchangeGainLossJournal.create_exchange_gain_loss_gbch_payable_journal(params) 
      message = "Exchange Gain Loss Closing"
        if not  params[:valid_comb_amount] ==  params[:valid_comb_amount_non_idr ]
          ta = TransactionData.where(
            :id => transaction_data_id
          ).first 
        
          if (closing.valid_comb_amount > closing.valid_comb_amount_non_idr)
            # Debit AccountGBCHPayable Credit ExchangeGain
             TransactionDataDetail.create_object(
            :transaction_data_id => ta.id,        
            :account_id          => params[:account_id]   ,
            :entry_case          => NORMAL_BALANCE[:debit]     ,
            :amount              => (params[:valid_comb_amount] - params[:valid_comb_amount_non_idr]).round(2) ,
            :description => "Debit AccountGBCHPayable"
            )
    
          TransactionDataDetail.create_object(
            :transaction_data_id => ta.id,        
            :account_id          => Account.find_by_code(ACCOUNT_CODE[:pendapatan_selisih_kurs][:code]).id        ,
            :entry_case          => NORMAL_BALANCE[:credit]     ,
            :amount              => (params[:valid_comb_amount] - params[:valid_comb_amount_non_idr]).round(2),
            :description => "Credit ExchangeGain"
            )
          end
          
          if (closing.valid_comb_amount < closing.valid_comb_amount_non_idr)
            # Credit AccountGBCHPayable Debit ExchangeLoss
            TransactionDataDetail.create_object(
            :transaction_data_id => ta.id,        
            :account_id          => params[:account_id]     ,
            :entry_case          => NORMAL_BALANCE[:debit]     ,
            :amount              => (params[:valid_comb_amount_non_idr] - params[:valid_comb_amount]).round(2) ,
            :description => "Credit AccountGBCHPayable"
            )
    
            TransactionDataDetail.create_object(
            :transaction_data_id => ta.id,        
            :account_id          => Account.find_by_code(ACCOUNT_CODE[:rugi_selisih_kurs][:code]).id        ,
            :entry_case          => NORMAL_BALANCE[:credit]     ,
            :amount              => (params[:valid_comb_amount_non_idr] - params[:valid_comb_amount]).round(2) ,
            :description => "Debit ExchangeLoss"
            )
            
          end
        end
    end
    
    def CreateExchangeGainLossJournal.create_exchange_gain_loss_account_receivable_journal(params) 
      message = "Exchange Gain Loss Closing"
        if not  params[:valid_comb_amount] ==  params[:valid_comb_amount_non_idr ]
          ta = TransactionData.where(
            :id => transaction_data_id
          ).first 
        
          if (closing.valid_comb_amount > closing.valid_comb_amount_non_idr)
            # Credit AccountReceivable Debit ExchangeLoss
             TransactionDataDetail.create_object(
            :transaction_data_id => ta.id,        
            :account_id          => params[:account_id]   ,
            :entry_case          => NORMAL_BALANCE[:credit]     ,
            :amount              => (params[:valid_comb_amount] - params[:valid_comb_amount_non_idr]).round(2) ,
            :description => "Credit AccountReceivable"
            )
    
          TransactionDataDetail.create_object(
            :transaction_data_id => ta.id,        
            :account_id          => Account.find_by_code(ACCOUNT_CODE[:rugi_selisih_kurs][:code]).id        ,
            :entry_case          => NORMAL_BALANCE[:debit]     ,
            :amount              => (params[:valid_comb_amount] - params[:valid_comb_amount_non_idr]).round(2),
            :description => "Debit ExchangeLoss"
            )
          end
          
          if (closing.valid_comb_amount < closing.valid_comb_amount_non_idr)
            # Debit AccountReceivable Credit ExchangeGain
            TransactionDataDetail.create_object(
            :transaction_data_id => ta.id,        
            :account_id          => params[:account_id]     ,
            :entry_case          => NORMAL_BALANCE[:debit]     ,
            :amount              => (params[:valid_comb_amount_non_idr] - params[:valid_comb_amount]).round(2) ,
            :description => "Debit AccountReceivbale"
            )
    
            TransactionDataDetail.create_object(
            :transaction_data_id => ta.id,        
            :account_id          => Account.find_by_code(ACCOUNT_CODE[:pendapatan_selisih_kurs][:code]).id        ,
            :entry_case          => NORMAL_BALANCE[:credit]     ,
            :amount              => (params[:valid_comb_amount_non_idr] - params[:valid_comb_amount]).round(2) ,
            :description => "Credit ExchangeGain"
            )
            
          end
        end
    end
    
    def CreateExchangeGainLossJournal.create_exchange_gain_loss_gbch_receivable_journal(params) 
      message = "Exchange Gain Loss Closing"
        if not  params[:valid_comb_amount] ==  params[:valid_comb_amount_non_idr ]
          ta = TransactionData.where(
            :id => transaction_data_id
          ).first
        
          if (closing.valid_comb_amount > closing.valid_comb_amount_non_idr)
            # Credit GBCHReceivable Debit ExchangeLoss
             TransactionDataDetail.create_object(
            :transaction_data_id => ta.id,        
            :account_id          => params[:account_id]   ,
            :entry_case          => NORMAL_BALANCE[:credit]     ,
            :amount              => (params[:valid_comb_amount] - params[:valid_comb_amount_non_idr]).round(2) ,
            :description => "Credit GBCHReceivable"
            )
    
          TransactionDataDetail.create_object(
            :transaction_data_id => ta.id,        
            :account_id          => Account.find_by_code(ACCOUNT_CODE[:rugi_selisih_kurs][:code]).id        ,
            :entry_case          => NORMAL_BALANCE[:debit]     ,
            :amount              => (params[:valid_comb_amount] - params[:valid_comb_amount_non_idr]).round(2),
            :description => "Debit ExchangeLoss"
            )
          end
          
          if (closing.valid_comb_amount < closing.valid_comb_amount_non_idr)
            # Debit GBCHReceivable Credit ExchangeGain
            TransactionDataDetail.create_object(
            :transaction_data_id => ta.id,        
            :account_id          => params[:account_id]     ,
            :entry_case          => NORMAL_BALANCE[:debit]     ,
            :amount              => (params[:valid_comb_amount_non_idr] - params[:valid_comb_amount]).round(2) ,
            :description => "Debit GBCHReceivable"
            )
    
            TransactionDataDetail.create_object(
            :transaction_data_id => ta.id,        
            :account_id          => Account.find_by_code(ACCOUNT_CODE[:pendapatan_selisih_kurs][:code]).id        ,
            :entry_case          => NORMAL_BALANCE[:credit]     ,
            :amount              => (params[:valid_comb_amount_non_idr] - params[:valid_comb_amount]).round(2) ,
            :description => "Credit ExchangeGain"
            )
            
          end
        end
    end
    
    
    def CreateExchangeGainLossJournal.undo_create_exchange_gain_loss_journal(object)
      last_transaction_data = TransactionData.where(
        :transaction_source_id => object.id , 
        :transaction_source_type => object.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:closing],
        :is_contra_transaction => false
      ).order("id DESC").first 
      last_transaction_data.create_contra_and_confirm if not last_transaction_data.nil?
    end

  end
end