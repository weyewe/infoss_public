module AccountingService
  class CreateDeliveryOrderJournal
  def CreateDeliveryOrderJournal.create_confirmation_journal(delivery_order) 
    message = "DeliveryOrder"
      ta = TransactionData.create_object({
        :transaction_datetime => delivery_order.delivery_date,
        :description =>  message,
        :transaction_source_id => delivery_order.id , 
        :transaction_source_type => delivery_order.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:delivery_order_journal],
        :is_contra_transaction => false 
      }, true )

    
#      Debit COGS, Credit Raw
    
    #     Debit  COGS
    TransactionDataDetail.create_object(
      :transaction_data_id => ta.id,        
      :account_id          => Account.find_by_code(ACCOUNT_CODE[:harga_pokok_penjualan_level_3][:code]).id    ,
      :entry_case          => NORMAL_BALANCE[:debit]     ,
      :amount              => (delivery_order.total_cogs).round(2),
      :description => "Debit COGS"
      )

#     Credit Raw
    delivery_order.delivery_order_details.each do |dod|
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => dod.item.item_type.account_id ,
        :entry_case          => NORMAL_BALANCE[:credit]     ,
        :amount              => (dod.cogs).round(2),
        :description => "Credit Raw"
      )
    end
    ta.confirm
  end
    
    def CreateDeliveryOrderJournal.undo_create_confirmation_journal(object)
      last_transaction_data = TransactionData.where(
        :transaction_source_id => object.id , 
        :transaction_source_type => object.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:delivery_order_journal],
        :is_contra_transaction => false
      ).order("id DESC").first 
      last_transaction_data.create_contra_and_confirm if not last_transaction_data.nil?
    end
  end
end