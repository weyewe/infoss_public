class CashBank < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :exchange_id
  has_many :cash_bank_adjustments
  belongs_to :receipt_voucher
  belongs_to :exchange
  
  has_one :account 
  
  validate :valid_exchange_id
  
  def valid_exchange_id
    return if exchange_id.nil?
    exchange = Exchange.find_by_id(exchange_id)
    if exchange.nil? 
      self.errors.add(:exchange_id, "Harus ada currency")
      return self
    end
  end 
  
  
  def self.create_object( params )
    new_object  = self.new
    new_object.name = params[:name]
    new_object.description = params[:description]
    new_object.is_bank = params[:is_bank]
    new_object.exchange_id = params[:exchange_id]
    new_object.code = params[:code]
    if new_object.save
      new_object.account_id = Account.create_object_from_cash_bank(new_object).id
      new_object.save
    end
    return new_object
  end
  
  def self.active_objects
    self 
  end
  
  def update_object( params )    
    if self.exchange_id != params[:exchange_id]
      if CashBankAdjustment.where(:cash_bank_id => self.id).count > 0
        self.errors.add(:generic_errors, "Sudah terpakai di CashBankAdjustment")
        return self
      end
      if CashBankMutation.where{
        ((source_cash_bank_id.eq self.id))|
        ((target_cash_bank_id.eq self.id))
        }.count > 0
        self.errors.add(:generic_errors, "Sudah terpakai di CashBankMutation")
        return self
      end
      if ReceiptVoucher.where(:cash_bank_id => self.id).count > 0
        self.errors.add(:generic_errors, "Sudah terpakai di ReceiptVoucher")
        return self
      end
      if PaymentVoucher.where(:cash_bank_id => self.id).count > 0
        self.errors.add(:generic_errors, "Sudah terpakai di PaymentVoucher")
        return self
      end
      if BankAdministration.where(:cash_bank_id => self.id).count > 0
        self.errors.add(:generic_errors, "Sudah terpakai di BankAdministration")
        return self
      end
      if TransactionDataDetail.where(:account_id => self.account_id).count > 0 
        self.errors.add(:generic_errors,"Account CashBank sudah terpakai")
        return self
      end
    end
    self.name = params[:name]
    self.description = params[:description]
    self.is_bank = params[:is_bank]
    self.exchange_id = params[:exchange_id]
    if self.save
      Account.where(:id => self.account_id).first.delete_object
      self.account_id = Account.create_object_from_cash_bank(self).id
      self.save
    end
    return self
  end
  
  def delete_object
    if CashBankAdjustment.where(:cash_bank_id => self.id).count > 0
      self.errors.add(:generic_errors, "Sudah terpakai di CashBankAdjustment")
      return self
    end
    if CashBankMutation.where{
      ((source_cash_bank_id.eq self.id))|
      ((target_cash_bank_id.eq self.id))
      }.count > 0
      self.errors.add(:generic_errors, "Sudah terpakai di CashBankMutation")
      return self
    end
    if ReceiptVoucher.where(:cash_bank_id => self.id).count > 0
      self.errors.add(:generic_errors, "Sudah terpakai di ReceiptVoucher")
      return self
    end
    if PaymentVoucher.where(:cash_bank_id => self.id).count > 0
      self.errors.add(:generic_errors, "Sudah terpakai di PaymentVoucher")
      return self
    end
    if BankAdministration.where(:cash_bank_id => self.id).count > 0
        self.errors.add(:generic_errors, "Sudah terpakai di BankAdministration")
        return self
    end
    if TransactionDataDetail.where(:account_id => self.account_id).count > 0 
      self.errors.add(:generic_errors,"Account CashBank sudah terpakai")
      return self
    end
    Account.where(:id => self.account_id).first.delete_object
    self.destroy
    return self
  end
  
  def update_amount( amount )
    self.amount += amount
    self.save 
  end
  
end
