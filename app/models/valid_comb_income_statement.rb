class ValidCombIncomeStatement < ActiveRecord::Base
    
    def self.create_object( params) 
        new_object = self.new 
        new_object.account_id = params[:account_id]
        new_object.closing_id = params[:closing_id]
        new_object.amount = params[:amount]
        if new_object.save
        end
        return new_object
    end
    
    def delete_object
        self.destroy
        return self
    end
    
end
