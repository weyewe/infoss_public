class Closing < ActiveRecord::Base
  has_many :valid_combs
  has_many :closing_details
  validates_presence_of :period
  validates_presence_of :year_period
  validates_presence_of :beginning_period
  validates_presence_of :end_date_period
  # validates_presence_of :is_year
  
  validate :end_period_must_be_later_than_any_start_period
  
  
  def self.active_objects
    return self
  end
  
  def active_children
    return self.closing_details
  end
  
  def self.is_date_closed(check_date)
    begin_date = check_date
    end_date = check_date + 1.days
    return Closing.where{
      (is_closed.eq true) &&
      (beginning_period.lte begin_date) &&
      (end_date_period.gt end_date)
    }
    
  end
  
  def end_period_must_be_later_than_any_start_period
    return if not end_date_period.present? 
    current_end_period = self.end_date_period 
    if self.persisted?
      current_closing_id = self.id 
      if Closing.where{
        ( id.not_eq current_closing_id ) & (
          ( beginning_period.gte  current_end_period ) | 
          ( end_date_period.gte current_end_period )
        )
        
      }.count > 1
        self.errors.add(:end_period, "Sudah ada closing yang tanggal mulai lebih akhir daripada tanggal end_period anda")
        return self 
      end
      
    else
      if Closing.where{
        ( beginning_period.gte  current_end_period ) | 
        ( end_date_period.gte current_end_period )
      }.count > 0 
        self.errors.add(:end_period, "Sudah ada closing yang tanggal mulai lebih akhir daripada tanggal end_period anda")
        return self 
      end
    end
    
  end
  
  def self.create_object( params) 
    new_object = self.new 
    new_object.period = params[:period]
    new_object.year_period = params[:year_period]
    new_object.beginning_period = params[:beginning_period]
    new_object.end_date_period = params[:end_date_period]
    new_object.is_year_closing = params[:is_year_closing]
    if new_object.save
      new_object.generate_closing_detail(new_object.id)
    end
    return new_object
  end
  
  def update_object(params)
    if self.is_closed? 
      self.errors.add(:generic_errors, "Sudah di close")
      return self
    end
    self.period = params[:period]
    self.year_period = params[:year_period]
    self.beginning_period = params[:beginning_period]
    self.end_date_period = params[:end_date_period]
    self.is_year_closing = params[:is_year_closing]
    if self.save
      self.closing_details.each do |clsd|
        clsd.delete_object
      end
      generate_closing_detail(self.id)
    end
    return self
  end
  
  def close_object(params)
    if self.is_closed? 
      self.errors.add(:generic_errors, "Sudah di close")
      return self
    end
    
    self.is_closed = true
    self.closed_at = params[:closed_at]
    if self.save
      self.generate_valid_combs
      self.generate_valid_combs_for_non_children
    end
    return self
  end
  
  def open_object
    if not self.is_closed?
      self.errors.add(:generic_errors, "belum di close")
      return self 
    end
    self.is_closed =false
    self.closed_at = nil
    if self.save
      AccountingService::CreateExchangeGainLossJournal.undo_create_exchange_gain_loss_journal(self)
      ValidComb.where(:closing_id => self.id).each do |valid_comb|
        if not valid_comb.valid_comb_non_base_exchange.nil?
          valid_comb.valid_comb_non_base_exchange.delete_object
          valid_comb.delete_object
        end
      end
    end  
  end
  
  
  def delete_object
    if self.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    
    self.destroy
    return self
  end
  
  def generate_closing_detail(closing_id)
    Exchange.all.each do |exc|
      ClosingDetail.create_object(
        :closing_id => closing_id,
        :exchange_id => exc.id)
    end
  end
  
  def previous_closing 
    previous_closing = nil 
    current_end_period = self.end_date_period
    if self.persisted?
      current_id = self.id 
      previous_closing = Closing.where{
        (id.not_eq current_id) & (
          (end_date_period.lt current_end_period)
        )
        
      }.order("id DESC").first
    else
      previous_closing = Closing.where{
        (end_date_period.lt current_end_period)
      }.order("id DESC").first
    end
    
    return previous_closing 
  end
  
  
  def generate_valid_combs
    self.generate_exchange_gain_loss
    start_transaction = beginning_period
    end_transaction = end_date_period
    leaves_account = Account.all_ledger_accounts
    # leaves_account_id_list = leaves_account.map{|x| x.id }
    
    leaves_account.each do |leaf_account|
      valid_comb_amount = BigDecimal("0")
      valid_comb_amount_non_idr = BigDecimal("0")
      total_debit = BigDecimal("0")
      total_credit = BigDecimal("0")
      total_debit_non_idr = BigDecimal("0")
      total_credit_non_idr = BigDecimal("0")
      cash_bank = CashBank.where(:account_id => leaf_account.id)
      account_payable = Exchange.where(:account_payable_id => leaf_account.id)
      account_receivable = Exchange.where(:account_receivable_id => leaf_account.id)
      gbch_payable = Exchange.where(:gbch_payable_id => leaf_account.id)
      gbch_receivable = Exchange.where(:gbch_receivable_id => leaf_account.id)
    
      if not start_transaction.nil?
        total_debit = TransactionDataDetail.joins(:transaction_data).where{
          ( transaction_data.transaction_datetime.gte start_transaction) & 
          ( transaction_data.transaction_datetime.lt end_transaction) & 
          ( account_id.eq leaf_account.id ) & 
          ( entry_case.eq NORMAL_BALANCE[:debit])
        }.sum("amount")
  
        total_credit = TransactionDataDetail.joins(:transaction_data).where{
          ( transaction_data.transaction_datetime.gte start_transaction) & 
          ( transaction_data.transaction_datetime.lt end_transaction) & 
          ( account_id.eq leaf_account.id ) & 
          ( entry_case.eq NORMAL_BALANCE[:credit])
        }.sum("amount")
        
        if cash_bank.count > 0 or account_payable.count > 0 or account_receivable.count > 0 or 
          gbch_payable.count > 0 or gbch_receivable.count > 0
            total_debit_non_idr = TransactionDataDetail.joins(:transaction_data,:transaction_data_non_base_exchange_details)
            .where{
            ( transaction_data.transaction_datetime.gte start_transaction) & 
            ( transaction_data.transaction_datetime.lt end_transaction) & 
            ( account_id.eq leaf_account.id ) & 
            ( entry_case.eq NORMAL_BALANCE[:debit])
            }.sum("transaction_data_non_base_exchange_details.amount")
          
            total_credit_non_idr = TransactionDataDetail.joins(:transaction_data,:transaction_data_non_base_exchange_details)
            .where{
            ( transaction_data.transaction_datetime.gte start_transaction) & 
            ( transaction_data.transaction_datetime.lt end_transaction) & 
            ( account_id.eq leaf_account.id ) & 
            ( entry_case.eq NORMAL_BALANCE[:credit])
            }.sum("transaction_data_non_base_exchange_details.amount")
        end
      else
        total_debit = TransactionDataDetail.joins(:transaction_data).where{
          ( transaction_data.transaction_datetime.lt end_transaction) & 
          ( account_id.eq leaf_account.id ) & 
          ( entry_case.eq NORMAL_BALANCE[:debit])
        }.sum("amount")
  
        total_credit = TransactionDataDetail.joins(:transaction_data).where{
          ( transaction_data.transaction_datetime.lt end_transaction) & 
          ( account_id.eq leaf_account.id ) & 
          ( entry_case.eq NORMAL_BALANCE[:credit])
        }.sum("amount")
      
        if cash_bank.count > 0 or account_payable.count > 0 or account_receivable.count > 0 or 
          gbch_payable.count > 0 or gbch_receivable.count > 0
            total_debit_non_idr = TransactionDataDetail.joins(:transaction_data,:transaction_data_non_base_exchange_details)
            .where{
            ( transaction_data.transaction_datetime.gte start_transaction) & 
            ( transaction_data.transaction_datetime.lt end_transaction) & 
            ( account_id.eq leaf_account.id ) & 
            ( entry_case.eq NORMAL_BALANCE[:debit])
            }.sum("transaction_data_non_base_exchange_details.amount")
          
            total_credit_non_idr = TransactionDataDetail.joins(:transaction_data,:transaction_data_non_base_exchange_details)
            .where{
            ( transaction_data.transaction_datetime.gte start_transaction) & 
            ( transaction_data.transaction_datetime.lt end_transaction) & 
            ( account_id.eq leaf_account.id ) & 
            ( entry_case.eq NORMAL_BALANCE[:credit])
            }.sum("transaction_data_non_base_exchange_details.amount")
        end  
      
      end
      # puts "#{leaf_account.name} (#{leaf_account.code}) (#{leaf_account.normal_balance}) total_debit = #{total_debit}  total_credit = #{total_credit}"
      if leaf_account.normal_balance == NORMAL_BALANCE[:debit]
        valid_comb_amount = total_debit - total_credit
        valid_comb_amount_non_idr = total_debit_non_idr - total_credit_non_idr
      else
        valid_comb_amount = total_credit -  total_debit
        valid_comb_amount_non_idr = total_credit_non_idr - total_debit_non_idr
      end
    
      final_valid_comb_amount = valid_comb_amount + ValidComb.previous_closing_valid_comb_amount( previous_closing, leaf_account )
      final_valid_comb_amount_non_idr = valid_comb_amount_non_idr + ValidCombNonBaseExchange.previous_closing_valid_comb_amount(previous_closing,leaf_account)
      entry_case = leaf_account.normal_balance  
      
      if final_valid_comb_amount < BigDecimal("0")
        entry_case = NORMAL_BALANCE[:debit] if leaf_account.normal_balance == NORMAL_BALANCE[:credit] 
        entry_case = NORMAL_BALANCE[:credit] if leaf_account.normal_balance == NORMAL_BALANCE[:debit] 
      end
    
      # puts " #{leaf_account.name} (#{leaf_account.code}) :: #{valid_comb_amount} "
      
      valid_comb = ValidComb.create_object(
        :account_id => leaf_account.id,
        :closing_id => self.id,
        :amount => final_valid_comb_amount.abs,
        :entry_case => entry_case
      )
    
      if cash_bank.count > 0 or account_payable.count > 0 or account_receivable.count > 0 or 
        gbch_payable.count > 0 or gbch_receivable.count > 0
        ValidCombNonBaseExchange.create_object(
        :valid_comb_id => valid_comb.id,
        :amount => final_valid_comb_amount_non_idr.abs
        )  
      end
      
    end
    parent_id_list = leaves_account.map{|x| x.parent_id }.uniq
    
    if parent_id_list.length != 0
      generate_parent_valid_combs(  parent_id_list ) 
    end
    
  end
  
  
  def generate_exchange_for_cash_bank(transaction_data_id,cash_bank,start_transaction,end_transaction,leaf_account_id,leaf_account)
    valid_comb_amount = BigDecimal("0")
    valid_comb_amount_non_idr = BigDecimal("0")
    total_debit = BigDecimal("0")
    total_credit = BigDecimal("0")
    total_debit_non_idr = BigDecimal("0")
    total_credit_non_idr = BigDecimal("0")
    latest_rate = self.closing_details.where(
      :exchange_id => cash_bank.exchange_id).first
    
    # latest_rate = ExchangeRate.get_latest( 
    #   :ex_rate_date => end_transaction , 
    #   :exchange_id => cash_bank.exchange_id  )
    if not start_transaction.nil?
      total_debit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.gte start_transaction) & 
        ( transaction_data.transaction_datetime.lt end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:debit])
      }.sum("amount")
    
      total_credit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.gte start_transaction) & 
        ( transaction_data.transaction_datetime.lt end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:credit])
      }.sum("amount")
    
      total_debit_non_idr = TransactionDataDetail.joins(:transaction_data,:transaction_data_non_base_exchange_details)
        .where{
        ( transaction_data.transaction_datetime.gte start_transaction) & 
        ( transaction_data.transaction_datetime.lt end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:debit])
      }.sum("transaction_data_non_base_exchange_details.amount")
      
      total_credit_non_idr = TransactionDataDetail.joins(:transaction_data,:transaction_data_non_base_exchange_details)
        .where{
        ( transaction_data.transaction_datetime.gte start_transaction) & 
        ( transaction_data.transaction_datetime.lt end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:credit])
      }.sum("transaction_data_non_base_exchange_details.amount")
    else
      total_debit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.lt end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:debit])
      }.sum("amount")
    
      total_credit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.lt end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:credit])
      }.sum("amount")
      
      total_debit_non_idr = TransactionDataDetail.joins(:transaction_data,:transaction_data_non_base_exchange_details)
          .where{
          ( transaction_data.transaction_datetime.lt end_transaction) & 
          ( account_id.eq leaf_account.id ) & 
          ( entry_case.eq NORMAL_BALANCE[:debit])
      }.sum("transaction_data_non_base_exchange_details.amount")
        
      total_credit_non_idr = TransactionDataDetail.joins(:transaction_data,:transaction_data_non_base_exchange_details)
        .where{
        ( transaction_data.transaction_datetime.lt end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:credit])
      }.sum("transaction_data_non_base_exchange_details.amount")
    end
    
    if leaf_account.normal_balance == NORMAL_BALANCE[:debit]
      valid_comb_amount = total_debit - total_credit
      valid_comb_amount_non_idr = ((total_debit_non_idr - total_credit_non_idr) * latest_rate.rate).round(2)
    else
      valid_comb_amount = total_credit -  total_debit
      valid_comb_amount_non_idr = ((total_debit_non_idr - total_debit_non_idr) * latest_rate.rate).round(2)
    end
    
    final_valid_comb_amount = valid_comb_amount + ValidComb.previous_closing_valid_comb_amount( previous_closing, leaf_account )
    final_valid_comb_amount_non_idr = valid_comb_amount + 
      (ValidCombNonBaseExchange.previous_closing_valid_comb_amount( previous_closing,leaf_account ) *
      latest_rate.rate).round(2)
    AccountingService::CreateExchangeGainLossJournal.create_exchange_gain_loss_cash_bank_journal(
     :transaction_data_id => transaction_data_id,
     :valid_comb_amount => final_valid_comb_amount,
     :valid_comb_amount_non_idr => final_valid_comb_amount_non_idr,
     :account_id => cash_bank.account_id
     )
    
  end 
  
  def generate_exchange_for_account_payable(transaction_data_id,account_payable,start_transaction,end_transaction,leaf_account_id,leaf_account)
    valid_comb_amount = BigDecimal("0")
    valid_comb_amount_non_idr = BigDecimal("0")
    total_debit = BigDecimal("0")
    total_credit = BigDecimal("0")
    total_debit_non_idr = BigDecimal("0")
    total_credit_non_idr = BigDecimal("0")
    latest_rate = self.closing_details.where(
      :exchange_id => account_payable.id).first
    # latest_rate = ExchangeRate.get_latest( 
    #   :ex_rate_date => end_transaction , 
    #   :exchange_id => account_payable.id  )
    if not start_transaction.nil?
      total_debit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.gte start_transaction) & 
        ( transaction_data.transaction_datetime.lt end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:debit])
      }.sum("amount")
    
      total_credit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.gte start_transaction) & 
        ( transaction_data.transaction_datetime.lt end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:credit])
      }.sum("amount")
    
      total_debit_non_idr = TransactionDataDetail.joins(:transaction_data,:transaction_data_non_base_exchange_details)
        .where{
        ( transaction_data.transaction_datetime.gte start_transaction) & 
        ( transaction_data.transaction_datetime.lt end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:debit])
      }.sum("transaction_data_non_base_exchange_details.amount")
      
      total_credit_non_idr = TransactionDataDetail.joins(:transaction_data,:transaction_data_non_base_exchange_details)
        .where{
        ( transaction_data.transaction_datetime.gte start_transaction) & 
        ( transaction_data.transaction_datetime.lt end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:credit])
      }.sum("transaction_data_non_base_exchange_details.amount")
    else
      total_debit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.lt end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:debit])
      }.sum("amount")
    
      total_credit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.lt end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:credit])
      }.sum("amount")
      
      total_debit_non_idr = TransactionDataDetail.joins(:transaction_data,:transaction_data_non_base_exchange_details)
          .where{
          ( transaction_data.transaction_datetime.lt end_transaction) & 
          ( account_id.eq leaf_account.id ) & 
          ( entry_case.eq NORMAL_BALANCE[:debit])
      }.sum("transaction_data_non_base_exchange_details.amount")
        
      total_credit_non_idr = TransactionDataDetail.joins(:transaction_data,:transaction_data_non_base_exchange_details)
        .where{
        ( transaction_data.transaction_datetime.lt end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:credit])
      }.sum("transaction_data_non_base_exchange_details.amount")
    end
    
    if leaf_account.normal_balance == NORMAL_BALANCE[:debit]
      valid_comb_amount = total_debit - total_credit
      valid_comb_amount_non_idr = ((total_debit_non_idr - total_credit_non_idr) * latest_rate.rate).round(2)
    else
      valid_comb_amount = total_credit -  total_debit
      valid_comb_amount_non_idr = ((total_debit_non_idr - total_debit_non_idr) * latest_rate.rate).round(2)
    end
    
    final_valid_comb_amount = valid_comb_amount + ValidComb.previous_closing_valid_comb_amount( previous_closing, leaf_account )
    final_valid_comb_amount_non_idr = valid_comb_amount + 
      (ValidCombNonBaseExchange.previous_closing_valid_comb_amount( previous_closing,leaf_account ) *
      latest_rate.rate).round(2)
    AccountingService::CreateExchangeGainLossJournal.create_exchange_gain_loss_account_payable_journal(
     :transaction_data_id => transaction_data_id,
     :valid_comb_amount => final_valid_comb_amount,
     :valid_comb_amount_non_idr => final_valid_comb_amount_non_idr,
     :account_id => account_payable.account_payable_id
     )
    
  end 
  
  def generate_exchange_for_account_receivable(transaction_data_id,account_receivable,start_transaction,end_transaction,leaf_account_id,leaf_account)
    valid_comb_amount = BigDecimal("0")
    valid_comb_amount_non_idr = BigDecimal("0")
    total_debit = BigDecimal("0")
    total_credit = BigDecimal("0")
    total_debit_non_idr = BigDecimal("0")
    total_credit_non_idr = BigDecimal("0")
    latest_rate = self.closing_details.where(
      :exchange_id => account_receivable.id).first
    # latest_rate = ExchangeRate.get_latest( 
    #   :ex_rate_date => end_transaction , 
    #   :exchange_id => account_receivable.id  )
    if not start_transaction.nil?
      total_debit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.gte start_transaction) & 
        ( transaction_data.transaction_datetime.lt end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:debit])
      }.sum("amount")
    
      total_credit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.gte start_transaction) & 
        ( transaction_data.transaction_datetime.lt end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:credit])
      }.sum("amount")
    
      total_debit_non_idr = TransactionDataDetail.joins(:transaction_data,:transaction_data_non_base_exchange_details)
        .where{
        ( transaction_data.transaction_datetime.gte start_transaction) & 
        ( transaction_data.transaction_datetime.lt end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:debit])
      }.sum("transaction_data_non_base_exchange_details.amount")
      
      total_credit_non_idr = TransactionDataDetail.joins(:transaction_data,:transaction_data_non_base_exchange_details)
        .where{
        ( transaction_data.transaction_datetime.gte start_transaction) & 
        ( transaction_data.transaction_datetime.lt end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:credit])
      }.sum("transaction_data_non_base_exchange_details.amount")
    else
      total_debit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.lt end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:debit])
      }.sum("amount")
    
      total_credit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.lt end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:credit])
      }.sum("amount")
      
      total_debit_non_idr = TransactionDataDetail.joins(:transaction_data,:transaction_data_non_base_exchange_details)
          .where{
          ( transaction_data.transaction_datetime.lt end_transaction) & 
          ( account_id.eq leaf_account.id ) & 
          ( entry_case.eq NORMAL_BALANCE[:debit])
      }.sum("transaction_data_non_base_exchange_details.amount")
        
      total_credit_non_idr = TransactionDataDetail.joins(:transaction_data,:transaction_data_non_base_exchange_details)
        .where{
        ( transaction_data.transaction_datetime.lt end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:credit])
      }.sum("transaction_data_non_base_exchange_details.amount")
    end
    
    if leaf_account.normal_balance == NORMAL_BALANCE[:debit]
      valid_comb_amount = total_debit - total_credit
      valid_comb_amount_non_idr = ((total_debit_non_idr - total_credit_non_idr) * latest_rate.rate).round(2)
    else
      valid_comb_amount = total_credit -  total_debit
      valid_comb_amount_non_idr = ((total_debit_non_idr - total_debit_non_idr) * latest_rate.rate).round(2)
    end
    
    final_valid_comb_amount = valid_comb_amount + ValidComb.previous_closing_valid_comb_amount( previous_closing, leaf_account )
    final_valid_comb_amount_non_idr = valid_comb_amount + 
      (ValidCombNonBaseExchange.previous_closing_valid_comb_amount( previous_closing,leaf_account ) *
      latest_rate.rate).round(2)
    AccountingService::CreateExchangeGainLossJournal.create_exchange_gain_loss_account_receivable_journal(
     :transaction_data_id => transaction_data_id,
     :valid_comb_amount => final_valid_comb_amount,
     :valid_comb_amount_non_idr => final_valid_comb_amount_non_idr,
     :account_id => account_receivable.account_receivable_id
     )
    
  end 
  
  def generate_exchange_for_gbch_payable(transaction_data_id,gbch_payable,start_transaction,end_transaction,leaf_account_id,leaf_account)
    valid_comb_amount = BigDecimal("0")
    valid_comb_amount_non_idr = BigDecimal("0")
    total_debit = BigDecimal("0")
    total_credit = BigDecimal("0")
    total_debit_non_idr = BigDecimal("0")
    total_credit_non_idr = BigDecimal("0")
    latest_rate = self.closing_details.where(
      :exchange_id => gbch_payable.id).first
    # latest_rate = ExchangeRate.get_latest( 
    #   :ex_rate_date => end_transaction , 
    #   :exchange_id => gbch_payable.id  )
    if not start_transaction.nil?
      total_debit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.gte start_transaction) & 
        ( transaction_data.transaction_datetime.lt end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:debit])
      }.sum("amount")
    
      total_credit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.gte start_transaction) & 
        ( transaction_data.transaction_datetime.lt end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:credit])
      }.sum("amount")
    
      total_debit_non_idr = TransactionDataDetail.joins(:transaction_data,:transaction_data_non_base_exchange_details)
        .where{
        ( transaction_data.transaction_datetime.gte start_transaction) & 
        ( transaction_data.transaction_datetime.lt end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:debit])
      }.sum("transaction_data_non_base_exchange_details.amount")
      
      total_credit_non_idr = TransactionDataDetail.joins(:transaction_data,:transaction_data_non_base_exchange_details)
        .where{
        ( transaction_data.transaction_datetime.gte start_transaction) & 
        ( transaction_data.transaction_datetime.lt end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:credit])
      }.sum("transaction_data_non_base_exchange_details.amount")
    else
      total_debit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.lt end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:debit])
      }.sum("amount")
    
      total_credit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.lt end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:credit])
      }.sum("amount")
      
      total_debit_non_idr = TransactionDataDetail.joins(:transaction_data,:transaction_data_non_base_exchange_details)
          .where{
          ( transaction_data.transaction_datetime.lt end_transaction) & 
          ( account_id.eq leaf_account.id ) & 
          ( entry_case.eq NORMAL_BALANCE[:debit])
      }.sum("transaction_data_non_base_exchange_details.amount")
        
      total_credit_non_idr = TransactionDataDetail.joins(:transaction_data,:transaction_data_non_base_exchange_details)
        .where{
        ( transaction_data.transaction_datetime.lt end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:credit])
      }.sum("transaction_data_non_base_exchange_details.amount")
    end
    
    if leaf_account.normal_balance == NORMAL_BALANCE[:debit]
      valid_comb_amount = total_debit - total_credit
      valid_comb_amount_non_idr = ((total_debit_non_idr - total_credit_non_idr) * latest_rate.rate).round(2)
    else
      valid_comb_amount = total_credit -  total_debit
      valid_comb_amount_non_idr = ((total_debit_non_idr - total_debit_non_idr) * latest_rate.rate).round(2)
    end
    
    final_valid_comb_amount = valid_comb_amount + ValidComb.previous_closing_valid_comb_amount( previous_closing, leaf_account )
    final_valid_comb_amount_non_idr = valid_comb_amount + 
      (ValidCombNonBaseExchange.previous_closing_valid_comb_amount( previous_closing,leaf_account ) *
      latest_rate.rate).round(2)
    AccountingService::CreateExchangeGainLossJournal.create_exchange_gain_loss_gbch_payable_journal(
     :transaction_data_id => transaction_data_id,
     :valid_comb_amount => final_valid_comb_amount,
     :valid_comb_amount_non_idr => final_valid_comb_amount_non_idr,
     :account_id => gbch_payable.gbch_payable_id
     )
    
  end 
  
  def generate_exchange_for_gbch_receivable(transaction_data_id,gbch_receivable,start_transaction,end_transaction,leaf_account_id,leaf_account)
    valid_comb_amount = BigDecimal("0")
    valid_comb_amount_non_idr = BigDecimal("0")
    total_debit = BigDecimal("0")
    total_credit = BigDecimal("0")
    total_debit_non_idr = BigDecimal("0")
    total_credit_non_idr = BigDecimal("0")
    latest_rate = self.closing_details.where(
      :exchange_id => gbch_receivable.id).first
    # latest_rate = ExchangeRate.get_latest( 
    #   :ex_rate_date => end_transaction , 
    #   :exchange_id => gbch_receivable.id  )
    if not start_transaction.nil?
      total_debit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.gte start_transaction) & 
        ( transaction_data.transaction_datetime.lt end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:debit])
      }.sum("amount")
    
      total_credit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.gte start_transaction) & 
        ( transaction_data.transaction_datetime.lt end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:credit])
      }.sum("amount")
    
      total_debit_non_idr = TransactionDataDetail.joins(:transaction_data,:transaction_data_non_base_exchange_details)
        .where{
        ( transaction_data.transaction_datetime.gte start_transaction) & 
        ( transaction_data.transaction_datetime.lt end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:debit])
      }.sum("transaction_data_non_base_exchange_details.amount")
      
      total_credit_non_idr = TransactionDataDetail.joins(:transaction_data,:transaction_data_non_base_exchange_details)
        .where{
        ( transaction_data.transaction_datetime.gte start_transaction) & 
        ( transaction_data.transaction_datetime.lt end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:credit])
      }.sum("transaction_data_non_base_exchange_details.amount")
    else
      total_debit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.lt end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:debit])
      }.sum("amount")
    
      total_credit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.lt end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:credit])
      }.sum("amount")
      
      total_debit_non_idr = TransactionDataDetail.joins(:transaction_data,:transaction_data_non_base_exchange_details)
          .where{
          ( transaction_data.transaction_datetime.lt end_transaction) & 
          ( account_id.eq leaf_account.id ) & 
          ( entry_case.eq NORMAL_BALANCE[:debit])
      }.sum("transaction_data_non_base_exchange_details.amount")
        
      total_credit_non_idr = TransactionDataDetail.joins(:transaction_data,:transaction_data_non_base_exchange_details)
        .where{
        ( transaction_data.transaction_datetime.lt end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:credit])
      }.sum("transaction_data_non_base_exchange_details.amount")
    end
    
    if leaf_account.normal_balance == NORMAL_BALANCE[:debit]
      valid_comb_amount = total_debit - total_credit
      valid_comb_amount_non_idr = ((total_debit_non_idr - total_credit_non_idr) * latest_rate.rate).round(2)
    else
      valid_comb_amount = total_credit -  total_debit
      valid_comb_amount_non_idr = ((total_debit_non_idr - total_debit_non_idr) * latest_rate.rate).round(2)
    end
    
    final_valid_comb_amount = valid_comb_amount + ValidComb.previous_closing_valid_comb_amount( previous_closing, leaf_account )
    final_valid_comb_amount_non_idr = valid_comb_amount + 
      (ValidCombNonBaseExchange.previous_closing_valid_comb_amount( previous_closing,leaf_account ) *
      latest_rate.rate).round(2)
    AccountingService::CreateExchangeGainLossJournal.create_exchange_gain_loss_gbch_receivable_journal(
     :transaction_data_id => transaction_data_id,
     :valid_comb_amount => final_valid_comb_amount,
     :valid_comb_amount_non_idr => final_valid_comb_amount_non_idr,
     :account_id => gbch_receivable.gbch_receivable_id
     )
    
  end 
  
  
  def generate_exchange_gain_loss
    start_transaction = beginning_period
    end_transaction = end_date_period
    transaction_data = AccountingService::CreateExchangeGainLossJournal.create_master_transaction_journal(
      :transaction_datetime => end_transaction,
      :transaction_source_id => self.id,
      :transaction_source_type => self.class.to_s,
      )
    leaves_account = Account.all_ledger_accounts
    
    leaves_account.each do |leaf_account|
    cash_bank = CashBank.where(:account_id => leaf_account.id)
    account_payable = Exchange.where(:account_payable_id => leaf_account.id)
    account_receivable = Exchange.where(:account_receivable_id => leaf_account.id)
    gbch_payable = Exchange.where(:gbch_payable_id => leaf_account.id)
    gbch_receivable = Exchange.where(:gbch_receivable_id => leaf_account.id)
    if cash_bank.count > 0 or account_payable.count > 0 or account_receivable.count > 0 or 
      gbch_payable.count > 0 or gbch_receivable.count > 0
      if cash_bank.count > 0 
        generate_exchange_for_cash_bank(transaction_data.id,cash_bank.first,start_transaction,end_transaction,leaf_account.id,leaf_account)
      end
      
      if account_payable.count > 0
        generate_exchange_for_account_payable(transaction_data.id,account_payable.first,start_transaction,end_transaction,leaf_account.id,leaf_account)
      end 
      
      if account_receivable.count > 0
        generate_exchange_for_account_receivable(transaction_data.id,account_receivable.first,start_transaction,end_transaction,leaf_account.id,leaf_account)
      end 
      
      if gbch_payable.count > 0
        generate_exchange_for_gbch_payable(transaction_data.id,gbch_payable.first,start_transaction,end_transaction,leaf_account.id,leaf_account)
      end 
      
      if gbch_receivable.count > 0
        generate_exchange_for_gbch_receivable(transaction_data.id,gbch_receivable.first,start_transaction,end_transaction,leaf_account.id,leaf_account)
      end 
    end
    end
    transaction_data.reload
    if not transaction_data.transaction_data_details.nil? 
      if  transaction_data.transaction_data_details.count == 0
        transaction_data.delete_object
      end
    else
      transaction_data.confirm
    end
  end 
  
  
 
  
  def generate_valid_combs_for_non_children
    Account.roots.each do |x|
      next if x.children.count != 0 
      valid_comb = ValidComb.create_object(
        :account_id => x.id,
        :closing_id => self.id,
        :amount => BigDecimal("0"),
        :entry_case => x.normal_balance
      )
    end
  end
  
  def generate_parent_valid_combs( node_id_list )
    node_account_list = Account.where(:id => node_id_list)
    node_account_list.each do | node | 
      next if ValidComb.where(:closing_id => self.id, :account_id => node.id).count == 1 
      children = node.children
      total_debit = ValidComb.where(
        :closing_id => self.id,
        :account_id => node.children.map{|x| x.id},
        :entry_case => NORMAL_BALANCE[:debit]
      ).sum("amount")
      
      
      total_credit = ValidComb.where(
        :closing_id => self.id,
        :account_id => node.children.map{|x| x.id},
        :entry_case => NORMAL_BALANCE[:credit]
      ).sum("amount")
      
      valid_comb_amount= BigDecimal("0")
      
      if node.normal_balance == NORMAL_BALANCE[:debit]
        valid_comb_amount = total_debit - total_credit
      else
        valid_comb_amount = total_credit -  total_debit
      end
      
      
      final_valid_comb_amount = valid_comb_amount + ValidComb.previous_closing_valid_comb_amount( previous_closing, node )
      # puts " #{node.name} (#{node.code}) :: #{final_valid_comb_amount} "
      entry_case = node.normal_balance  
      
      if final_valid_comb_amount < BigDecimal("0")
        entry_case = NORMAL_BALANCE[:debit] if node.normal_balance == NORMAL_BALANCE[:credit] 
        entry_case = NORMAL_BALANCE[:credit] if node.normal_balance == NORMAL_BALANCE[:debit] 
      end
      
      
      valid_comb = ValidComb.create_object(
        :account_id => node.id,
        :closing_id => self.id,
        :amount => final_valid_comb_amount.abs,
        :entry_case => entry_case
      )
      
      
    end
    
    parent_id_list = node_account_list.map{|x| x.parent_id }.uniq
    
    if parent_id_list.length != 0
      generate_parent_valid_combs(  parent_id_list ) 
    end
  end
  
end
