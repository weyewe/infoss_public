class ValidCombNonBaseExchange < ActiveRecord::Base
  belongs_to :valid_comb  
    
  def ValidCombNonBaseExchange.previous_closing_valid_comb_amount( previous_closing, leaf_account )
  return BigDecimal("0") if previous_closing.nil?
  
  previous_valid_comb = self.joins(:valid_comb)..where{
        ( valid_comb.closing_id.eq previous_closing.id) & 
        ( valid_comb.leaf_account_id.eq leaf_account.id)
      }.first
  
  return BigDecimal("0") if previous_valid_comb.nil?
  
  return previous_valid_comb.amount 
  end 
  
  def self.create_object( params) 
    new_object = self.new 
    new_object.valid_comb_id = params[:valid_comb_id]
    new_object.exchange_id = params[:exchange_id]
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
