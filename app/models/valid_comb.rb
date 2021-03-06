class ValidComb < ActiveRecord::Base
  belongs_to :account
  belongs_to :closing 
  belongs_to :valid_comb_non_base_exchange
  def ValidComb.previous_closing_valid_comb_amount( previous_closing, leaf_account )
    return BigDecimal("0") if previous_closing.nil?
    
    previous_valid_comb = self.where(:closing_id => previous_closing.id, :account_id => leaf_account.id).first
    
    return BigDecimal("0") if previous_valid_comb.nil?
    
    return previous_valid_comb.amount 
  end 
    
  def self.create_object( params) 
    new_object = self.new 
    new_object.account_id = params[:account_id]
    new_object.closing_id = params[:closing_id]
    new_object.amount = params[:amount]
    new_object.entry_case =  params[:entry_case]
    if new_object.save
    end
    
    return new_object
  end
  
  def delete_object
    self.destroy
    return self
  end
    
    
end
