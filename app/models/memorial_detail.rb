class MemorialDetail < ActiveRecord::Base
  belongs_to :memorial
  belongs_to :account
  
  validate :valid_memorial
  validate :valid_account
  validate :valid_status
  validate :valid_amount
  
  def valid_status
    return if status.nil?
    if not [1,2].include?( status.to_i ) 
      self.errors.add(:status, "Status harus ada")
      return self 
    end
  end
  
  def valid_amount
    if amount <= BigDecimal("0")
      self.errors.add(:amount, "Harus lebih besar dari 0")
      return self
    end
  end
  
  def valid_memorial
    return if  memorial_id.nil?
    ba = Memorial.find_by_id memorial_id
    if ba.nil? 
      self.errors.add(:memorial_id, "Harus ada Memorial id")
      return self 
    end
  end 
  
  def valid_account
    return if  account_id.nil?
    ac = Account.find_by_id account_id
    if ac.nil? 
      self.errors.add(:account_id, "Harus ada Account id")
      return self 
    end
  end 
    
  def self.create_object(params)
    new_object = self.new
    memorial = Memorial.find_by_id(params[:memorial_id])
    if not memorial.nil?
      if memorial.is_confirmed?
        new_object.errors.add(:generic_errors, "Sudah di konfirmasi")
        return new_object 
      end
    end
    new_object.memorial_id = params[:memorial_id]
    new_object.account_id = params[:account_id]
    new_object.status = params[:status]
    new_object.amount = BigDecimal( params[:amount] || '0')
    if new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    if self.memorial.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.memorial_id = params[:memorial_id]
    self.account_id = params[:account_id]
    self.status = params[:status]
    self.amount = BigDecimal( params[:amount] || '0')
    if self.save
    end
    return self
  end
  
  def delete_object
    if self.memorial.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.destroy
    return self
  end
  
end
