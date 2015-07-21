class ExchangeRate < ActiveRecord::Base
  
  validates_presence_of :exchange_id
  validates_presence_of :ex_rate_date
  validates_presence_of :rate
  validate :valid_exchange_id
  validate :valid_rate
  validate :duplicate_ex_rate_date_and_exchange_id
  
  belongs_to :exchange
  
  def duplicate_ex_rate_date_and_exchange_id
    previous_exchange_rate =  ExchangeRate.where(
      :exchange_id => exchange_id,
      :ex_rate_date => ex_rate_date
      ).first
    if self.persisted? 
      if  (not previous_exchange_rate.nil?) and  previous_exchange_rate.id != self.id
        self.errors.add(:generic_errors, "Sudah ada")
        return self 
      end
    else
      #       when the user is trying to create a home assignment
      if not previous_exchange_rate.nil?
        self.errors.add(:generic_errors, "Sudah ada")
        return self 
      end
    end
  end
  
  def valid_exchange_id
    return if exchange_id.nil? 
    exchange = Exchange.find_by_id(exchange_id)
    if exchange.nil? 
      self.errors.add(:exchange_id, "Harus ada Currency")
      return self
    end
  end 
    
  def valid_rate
    return if rate.nil? 
    if rate <= BigDecimal("0")
      self.errors.add(:rate, "Harus lebih besar dari 0")
      return self
    end
  end
  
  def self.create_object( params )
    new_object  = self.new
    new_object.exchange_id = params[:exchange_id]
    new_object.ex_rate_date = params[:ex_rate_date]
    new_object.rate = BigDecimal( params[:rate] || '0')
    new_object.save
    return new_object
  end
  
  def self.active_objects
    self
  end
  
  def self.get_latest( params )
    return self.where{
      (ex_rate_date.lte params[:ex_rate_date]) &
      (exchange_id.eq params[:exchange_id])
      }.first
  end
  
  def update_object( params ) 
    if PaymentRequest.where(:exchange_rate_id => self.id).count > 0 
      self.errors.add(:generic_errors, "Sudah terpakai di PaymentRequest")
      return self
    end
    if PurchaseInvoice.where(:exchange_rate_id => self.id).count > 0 
      self.errors.add(:generic_errors, "Sudah terpakai di PurchaseInvoice")
      return self
    end
    if PurchaseReceival.where(:exchange_rate_id => self.id).count > 0 
      self.errors.add(:generic_errors, "Sudah terpakai di PurchaseReceival")
      return self
    end
    if SalesInvoice.where(:exchange_rate_id => self.id).count > 0 
      self.errors.add(:generic_errors, "Sudah terpakai di SalesInvoice")
      return self
    end
    if PurchaseDownPayment.where(:exchange_rate_id => self.id).count > 0 
      self.errors.add(:generic_errors, "Sudah terpakai di PurchaseDownPayment")
      return self
    end
    if CashBankAdjustment.where(:exchange_rate_id => self.id).count > 0 
      self.errors.add(:generic_errors, "Sudah terpakai di CashbankAdjustment")
      return self
    end
    if CashBankMutation.where(:exchange_rate_id => self.id).count > 0 
      self.errors.add(:generic_errors, "Sudah terpakai di CashBankMutation")
      return self
    end
    if SalesDownPayment.where(:exchange_rate_id => self.id).count > 0 
      self.errors.add(:generic_errors, "Sudah terpakai di SalesDownPayment")
      return self
    end
    if BankAdministration.where(:exchange_rate_id => self.id).count > 0 
      self.errors.add(:generic_errors, "Sudah terpakai di BankAdministration")
      return self
    end
    if DeliveryOrder.where(:exchange_rate_id => self.id).count > 0 
      self.errors.add(:generic_errors, "Sudah terpakai di DeliveryOrder")
      return self
    end
    self.exchange_id = params[:exchange_id]
    self.ex_rate_date = params[:ex_rate_date]
    self.rate = BigDecimal( params[:rate] || '0')
    self.save
    return self
  end
  
  def delete_object
    if PaymentRequest.where(:exchange_rate_id => self.id).count > 0 
      self.errors.add(:generic_errors, "Sudah terpakai di PaymentRequest")
      return self
    end
    if PurchaseInvoice.where(:exchange_rate_id => self.id).count > 0 
      self.errors.add(:generic_errors, "Sudah terpakai di PurchaseInvoice")
      return self
    end
    if PurchaseReceival.where(:exchange_rate_id => self.id).count > 0 
      self.errors.add(:generic_errors, "Sudah terpakai di PurchaseReceival")
      return self
    end
    if SalesInvoice.where(:exchange_rate_id => self.id).count > 0 
      self.errors.add(:generic_errors, "Sudah terpakai di SalesInvoice")
      return self
    end
    if PurchaseDownPayment.where(:exchange_rate_id => self.id).count > 0 
      self.errors.add(:generic_errors, "Sudah terpakai di PurchaseDownPayment")
      return self
    end
    if CashBankAdjustment.where(:exchange_rate_id => self.id).count > 0 
      self.errors.add(:generic_errors, "Sudah terpakai di CashbankAdjustment")
      return self
    end
    if CashBankMutation.where(:exchange_rate_id => self.id).count > 0 
      self.errors.add(:generic_errors, "Sudah terpakai di CashBankMutation")
      return self
    end
    if SalesDownPayment.where(:exchange_rate_id => self.id).count > 0 
      self.errors.add(:generic_errors, "Sudah terpakai di SalesDownPayment")
      return self
    end
    if BankAdministration.where(:exchange_rate_id => self.id).count > 0 
      self.errors.add(:generic_errors, "Sudah terpakai di BankAdministration")
      return self
    end
    if DeliveryOrder.where(:exchange_rate_id => self.id).count > 0 
      self.errors.add(:generic_errors, "Sudah terpakai di DeliveryOrder")
      return self
    end
    self.destroy
    return self
  end
  
end
