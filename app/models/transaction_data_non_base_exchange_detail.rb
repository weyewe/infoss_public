class TransactionDataNonBaseExchangeDetail < ActiveRecord::Base
    belongs_to :transaction_data_detail
    
    def self.create_object( params) 
        new_object = self.new 
        new_object.transaction_data_detail_id = params[:transaction_data_detail_id]
        new_object.exchange_id = params[:exchange_id]
        new_object.amount = params[:amount]
        new_object.save 
        return new_object
    end
    
    
end
