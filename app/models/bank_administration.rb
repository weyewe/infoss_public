class BankAdministration < ActiveRecord::Base
  belongs_to :cash_bank
  belongs_to :exchange_rate
  has_many :bank_administration_details
  validates_presence_of :no_bukti
  validates_presence_of :administration_date
  validates_presence_of :cash_bank_id
 
  validate :valid_cash_bank_id
  
  def self.active_objects
    self
  end
  
  def active_children
    self.bank_administration_details 
  end
  
  def valid_cash_bank_id
    return if cash_bank_id.nil?
    cb = CashBank.find_by_id cash_bank_id
    if cb.nil? 
      self.errors.add(:cash_bank_id, "Harus ada CashBank Id")
      return self 
    end
  end    
  
  def self.create_object(params)
   
    new_object = self.new
    new_object.cash_bank_id = params[:cash_bank_id]
    new_object.administration_date = params[:administration_date]
    new_object.description = params[:description]
    new_object.no_bukti = params[:no_bukti]
    if new_object.save  
     new_object.code = "BADM-" + new_object.id.to_s  
      new_object.save
      new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    if self.bank_administration_details.count > 0
      self.errors.add(:generic_errors, "Sudah memiliki detail")
      return self 
    end
    self.cash_bank_id = params[:cash_bank_id]
    self.administration_date = params[:administration_date]
    self.code = params[:code]
    self.description = params[:description]
    self.no_bukti = params[:no_bukti]
    if self.save 
    end
    return self
  end
  
  def delete_object
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    if self.bank_administration_details.count > 0
      self.errors.add(:generic_errors, "Sudah memiliki detail")
      return self 
    end
    self.destroy
    return self
  end
  
  def confirm_object(params)
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    
    if self.bank_administration_details.count == 0
      self.errors.add(:generic_errors, "Tidak memiliki detail")
      return self 
    end
    
    if params[:confirmed_at].nil?
      self.errors.add(:generic_errors, "Harus ada tanggal konfirmasi")
      return self 
    end    
    
    self.is_confirmed = true
    self.confirmed_at = params[:confirmed_at]
    if self.save
      if self.cash_bank.exchange.is_base == false
        latest_exchange_rate = ExchangeRate.get_latest(
          :ex_rate_date => self.administration_date,
          :exchange_id => self.cash_bank.exchange_id
          )
        self.exchange_rate_id = latest_exchange_rate.id
        self.exchange_rate_amount = latest_exchange_rate.rate
      else
        self.exchange_rate_amount = 1
      end
      self.generate_cash_mutation
      AccountingService::CreateBankAdministrationJournal.create_confirmation_journal(self)
    end  
    return self
  end
  
  def unconfirm_object()
    if not self.is_confirmed?
      self.errors.add(:generic_errors, "belum di konfirmasi")
      return self 
    end
    self.is_confirmed = false
    self.confirmed_at = nil
    if self.save
      self.destroy_cash_mutation
       AccountingService::CreateBankAdministrationJournal.undo_create_confirmation_journal(self)
    end
    return self
  end
  
  def generate_cash_mutation
    status = ADJUSTMENT_STATUS[:addition]
    if self.amount < 0 
      status = ADJUSTMENT_STATUS[:deduction]
    end
    CashMutation.create_object(
        :source_class => self.class.to_s, 
        :source_id => self.id ,  
        :amount => self.amount ,  
        :status => status,  
        :mutation_date => self.administration_date ,  
        :cash_bank_id => self.cash_bank_id ,
        :source_code => self.code
       ) 
  end
  
  def destroy_cash_mutation
    CashMutation.where(
        :source_class => self.class.to_s, 
        :source_id => self.id
      ).each {|x| x.delete_object  }
  end
  
end
