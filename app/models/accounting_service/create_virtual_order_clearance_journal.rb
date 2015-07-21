module AccountingService
  class CreateVirtualOrderClearanceJournal
  def CreateVirtualOrderClearanceJournal.create_confirmation_journal(virtual_order_clearance) 
    message = "VirtualOrderClearance"
      ta = TransactionData.create_object({
        :transaction_datetime => virtual_order_clearance.clearance_date,
        :description =>  message,
        :transaction_source_id => virtual_order_clearance.id , 
        :transaction_source_type => virtual_order_clearance.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:virtual_order_clearance_journal],
        :is_contra_transaction => false 
      }, true )

    
#      Debit COGS, Credit Raw
    
    #     Debit  COGS
    TransactionDataDetail.create_object(
      :transaction_data_id => ta.id,        
      :account_id          => Account.find_by_code(ACCOUNT_CODE[:biaya_overhead_pabrik_level_3][:code]).id    ,
      :entry_case          => NORMAL_BALANCE[:debit]     ,
      :amount              => (virtual_order_clearance.total_waste_cogs).round(2),
      :description => "Debit COGS"
      )

#     Credit Raw
    virtual_order_clearance.virtual_order_clearance_details.each do |dod|
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => dod.virtual_delivery_order_detail.item.item_type.account_id ,
        :entry_case          => NORMAL_BALANCE[:credit]     ,
        :amount              => (dod.waste_cogs).round(2),
        :description => "Credit Raw"
      )
    end
    ta.confirm
  end
    
    def CreateVirtualOrderClearanceJournal.undo_create_confirmation_journal(object)
      last_transaction_data = TransactionData.where(
        :transaction_source_id => object.id , 
        :transaction_source_type => object.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:virtual_order_clearance_journal],
        :is_contra_transaction => false
      ).order("id DESC").first 
      last_transaction_data.create_contra_and_confirm if not last_transaction_data.nil?
    end
  end
end