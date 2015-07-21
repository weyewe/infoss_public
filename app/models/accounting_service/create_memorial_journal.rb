module AccountingService
  class CreateMemorialJournal
  def CreateMemorialJournal.create_confirmation_journal(memorial) 
      
    message = "Memorial"

      ta = TransactionData.create_object({
        :transaction_datetime => memorial.confirmed_at,
        :description =>  message,
        :transaction_source_id => memorial.id , 
        :transaction_source_type => memorial.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:memorial_journal],
        :is_contra_transaction => false ,
      }, true )
      
      # Debit/Credit User Input

      memorial.memorial_details.each do |md|
        TransactionDataDetail.create_object(
          :transaction_data_id => ta.id,        
          :account_id          => md.account_id       ,
          :entry_case          => md.status     ,
          :amount              => (md.amount).round(2),
          :description => "Debit/Credit User Input"
        )
      end
      ta.confirm
    end

    def CreateMemorialJournal.undo_create_confirmation_journal(object)
      last_transaction_data = TransactionData.where(
        :transaction_source_id => object.id , 
        :transaction_source_type => object.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:memorial_journal],
        :is_contra_transaction => false
      ).order("id DESC").first 
      last_transaction_data.create_contra_and_confirm if not last_transaction_data.nil?
    end

  end
end