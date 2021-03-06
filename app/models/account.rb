class Account < ActiveRecord::Base
  acts_as_nested_set
  
  has_many :valid_combs
  belongs_to :cash_bank 
  
  has_many :transaction_data_details
  
  # validates_uniqueness_of :name  
  
  
  
  validates_presence_of :name, :account_case , :code
  validates_uniqueness_of :code
  
  
  validate :parent_id_present_for_non_base_account
  validate :contra_account_must_be_ledger_account 
  # validate :original_account_id_must_present_in_contra_account
  # validate :original_account_id_must_be_ledger_account
  # validate :original_account_must_have_the_same_direct_ancestor
  validate :valid_account_case 
  
  def self.active_accounts
    self 
  end
  
  def exchange
    account_exchange = Exchange.where{
      ( account_payable_id.eq self.id  ) | 
      ( account_receivable_id.eq self.id  ) |  
      ( gbch_payable_id.eq self.id  ) |  
      ( gbch_receivable_id.eq self.id  )  
    }.first
    if account_exchange.nil?  
      return Exchange.where(:is_base => true).first
    end
    return account_exchange
  end
  
  def all_base_fields_present? 
    name.present? and
    account_case.present?  and 
    is_contra_account.present?  
  end
  
  def parent_id_present_for_non_base_account
    return if self.is_base_account? 
    if not parent_id.present?  or parent.nil? or  parent.account_case != ACCOUNT_CASE[:group]
      self.errors.add(:parent_id, "Harus ada parent account berupa group account, bukan ledger account")
      return self
    end
  end
  
  def contra_account_must_be_ledger_account
    return if not all_base_fields_present?
    if is_contra_account? and  account_case != ACCOUNT_CASE[:ledger]
      self.errors.add(:account_case, "Harus berupa ledger account")
      return self 
    end
  end
  
  def original_account_id_must_present_in_contra_account
    return if not all_base_fields_present?
    
    if is_contra_account? and not original_account_id.present? 
      self.errors.add(:original_account_id, "Harus ada account asli untuk membuat contra account")
      return self 
    end
  end
  
  
  def original_account_must_have_the_same_direct_ancestor
    return if not all_base_fields_present?
    parent_account = self.parent 
    return if parent_account.nil?
    return if original_account.nil?  
    
    if is_contra_account? and not parent.children.map{|x| x.id}.include?( original_account.id )
      self.errors.add(:original_account_id, "Harus memiliki parent account yang sama: #{parent_account.name}")
      return self 
    end
  end
  
  def original_account
    Account.find_by_id original_account_id
  end
  
  def original_account_id_must_be_ledger_account
    return if not all_base_fields_present?
     
    if is_contra_account? and not  original_account.nil? and 
        original_account.account_case != ACCOUNT_CASE[:ledger]
      self.errors.add(:original_account_id, "Akun normal harus ledger account")
      return self 
    end
  end
  
  def valid_account_case
    return if not all_base_fields_present?
    
    if not [
      ACCOUNT_CASE[:group],
      ACCOUNT_CASE[:ledger]
      ].include?(account_case) 
      
      self.errors.add(:account_case, "Harus ledger atau group")
      return self 
    end
  end
  
   
=begin
  About Contra Account 
  
  1. 
  Cash debit 10M
  capital credit 10M 
  
  2. 
  Machine debit 10M
  Machine debit 10M 
  
  3. 
  AccumulatedDepreciation credit 1M
  MachineDepreciationExpense debit 1M 
  
  4. 
  Total Machine Value is = Machine + AccumulatedDepreciation (debit, contra account) => so it is contra account
                          = 10 - 1 =  9M 
                          
  
  # so, in the transaction activity, what will the total debit be?
  self.transaction_data_details.where(:entry_case => :debit).sum("amount")
  
  the total_credit
  self.transaction_data_details.where(:entry_case => :credit).sum("amount")
=end
  
=begin
  Creating Generic Account
=end

  def parent 
    self.class.where(:id => self.parent_id).first 
  end
  
  def update_normal_balance
    return if self.is_base_account? 
    
    if not self.is_contra_account? 
      self.normal_balance = self.parent.normal_balance
    else
      self.normal_balance = NORMAL_BALANCE[:credit] if self.parent.normal_balance == NORMAL_BALANCE[:debit]
      self.normal_balance = NORMAL_BALANCE[:debit] if self.parent.normal_balance == NORMAL_BALANCE[:credit]
    end
    self.save 
  end

  def self.create_object(params)
    new_object                           = self.new 
    new_object.name                      = params[:name]
    new_object.code                      = params[:code]
    new_object.parent_id                 = params[:parent_id]
    new_object.account_case              = params[:account_case]  # ledger or group
    # new_object.is_contra_account         = params[:is_contra_account] 
    if new_object.save
      new_object.update_normal_balance
    end
    return new_object
  end
  
  def update_object( params ) 
    # puts "=======> Inside update_object\n"*5
    if self.is_base_account? 
      self.errors.add(:generic_errors, "Base Account tidak dapat di update")
      # puts "tidak bisa update base"
      return self 
    end
    if self.transaction_data_details.count != 0 and 
      (
        self.is_contra_account != params[:is_contra_account] or  
        self.account_case != params[:account_case] or
        self.parent_id != params[:parent_id]
      )
      
      self.errors.add(:generic_errors, "Akun sudah memiliki transaksi")
      return self  
    end
    
    
    # puts "inside update_object"
    # puts "the name : #{params[:name]}"
    
    self.name                      = params[:name]
    self.code                      = params[:code]
    self.parent_id                 = params[:parent_id]
    self.account_case              = params[:account_case]
    # self.is_contra_account         = params[:is_contra_account]
    # self.original_account_id       = params[:original_account_id]
    


    if self.save
      self.update_normal_balance
    end
    
    # puts "Total errors: #{self.errors.size}"
    
    return self
  end
  
  def has_transaction_activities_from_child_account?
    children_id_list = self.descendants.map{|x| x.id }
    TransactionDataDetail.where(:account_id => children_id_list).count != 0
  end
  
  def has_children_of_business_objects_account?
    self.descendants.where{ code.not_eq nil }.count != 0 
  end
  
  def destroy_child_accounts
    self.descendants.each do |x|
      x.destroy  
    end
  end
  
  def delete_object 
    if self.is_base_account?
      self.errors.add(:generic_errors, "Tidak dapat menghapus base account")
      return self 
    end
   
    
    if self.has_children_of_business_objects_account?
      self.errors.add(:generic_errors, "Tidak dapat menghapus account ini")
      return self 
    end
    
    
    if self.account_case == ACCOUNT_CASE[:ledger] and
        self.transaction_data_details.count != 0 
      self.errors.add(:generic_errors, "Tidak dapat dihapus karena ada posting berdasar akun ini")
      return self 
    else
      self.destroy 
    end
    
    if self.account_case == ACCOUNT_CASE[:group] and
      self.has_transaction_activities_from_child_account?  
      msg = "Tidak dapat dihapus karena sudah ada posting berdasar ledger dari akun ini"
      self.errors.add(:generic_errors, msg )
      return self 
    else
      self.destroy_child_accounts
      self.destroy 
    end
  end
  
  
=begin
  Creating base account
=end

   

  def self.all_ledger_accounts
    self.where(:account_case =>  ACCOUNT_CASE[:ledger])
  end


  def self.create_base_objects 
    converted = []
    ACCOUNT_CODE.each do |key,value|
      converted << [ key, value[:code] ] 
    end
    sorted = converted.sort_by {|x| x[1].to_i}

    sorted.each do |x|
      account = ACCOUNT_CODE[x[0]]
      
      parent_account = nil
      if not account[:parent_code].nil?
        parent_account = Account.find_by_code( account[:parent_code])
        if parent_account.nil?
          puts "account #{account[:name]} is erroneous"
        end
      end
      
      new_object = self.new
      new_object.name = account[:name]
      new_object.code = account[:code]
      new_object.normal_balance = account[:normal_balance]
      new_object.account_case = account[:status]
      new_object.code = account[:code]
      new_object.is_base_account = true 
      
      new_object.save
      
      # puts "ParentAccount code: #{parent_account.code}" if not parent_account.nil?
      # puts "current Account code: #{new_object.code}" if new_object.errors.messages.count  == 0
      
      if new_object.errors.messages.count  != 0
        # puts "The object: #{new_object.name}"
        # new_object.errors.messages.each {|x| puts "error: #{x}"}
      end
      new_object.move_to_child_of(parent_account) if not parent_account.nil?
      
    end
  end

  def self.create_object_from_exchange(exchange)
    created_account = []
#     create ar
    ar_account = Account.find_by_code(ACCOUNT_CODE[:piutang_usaha_level_2][:code])
    new_ar_account = self.new
    new_ar_account.code = ar_account.code + exchange.id.to_s
    new_ar_account.name = "Account Receivable " + exchange.name.to_s
    new_ar_account.account_case = ACCOUNT_CASE[:ledger]
    new_ar_account.parent_id = ar_account.id
    new_ar_account.normal_balance = ar_account.normal_balance
    new_ar_account.is_base_account = true
    new_ar_account.save
#     puts new_ar_account.id
    created_account << new_ar_account.id
#     create ar_gbch
    ar_gbch_account = Account.find_by_code(ACCOUNT_CODE[:piutang_gbch][:code])
    new_ar_gbch_account = self.new
    new_ar_gbch_account.code = ar_gbch_account.code + exchange.id.to_s
    new_ar_gbch_account.name = "GBCH Receivable " + exchange.name.to_s
    new_ar_gbch_account.account_case = ACCOUNT_CASE[:ledger]
    new_ar_gbch_account.parent_id = ar_gbch_account.id
    new_ar_gbch_account.normal_balance = ar_gbch_account.normal_balance
    new_ar_gbch_account.is_base_account = true
    new_ar_gbch_account.save
    created_account << new_ar_gbch_account.id
#     create ap
    ap_account = Account.find_by_code(ACCOUNT_CODE[:hutang_usaha_level_2][:code])
    new_ap_account = self.new
    new_ap_account.code =  ap_account.code + exchange.id.to_s
    new_ap_account.name = "Account Payable " + exchange.name.to_s
    new_ap_account.account_case = ACCOUNT_CASE[:ledger]
    new_ap_account.parent_id = ap_account.id
    new_ap_account.normal_balance = ap_account.normal_balance
    new_ap_account.is_base_account = true
    new_ap_account.save
    created_account << new_ap_account.id
#     create gbch_payable
    ap_gbch_payable_account = Account.find_by_code(ACCOUNT_CODE[:hutang_gbch][:code])
    new_ap_gbch_payable_account = self.new
    new_ap_gbch_payable_account.code =  ap_gbch_payable_account.code + exchange.id.to_s
    new_ap_gbch_payable_account.name = "GBCH Payable " + exchange.name.to_s
    new_ap_gbch_payable_account.account_case = ACCOUNT_CASE[:ledger]
    new_ap_gbch_payable_account.parent_id = ap_gbch_payable_account.id
    new_ap_gbch_payable_account.normal_balance = ap_gbch_payable_account.normal_balance
    new_ap_gbch_payable_account.is_base_account = true
    new_ap_gbch_payable_account.save
    created_account << new_ap_gbch_payable_account.id
    return created_account
  end
  
  
  def self.create_object_from_cash_bank(cash_bank)
    cash_bank_account = Account.find_by_code(ACCOUNT_CODE[:kas_dan_setara_kas][:code])
    new_cash_bank_account = self.new
    new_cash_bank_account.code = cash_bank_account.code + cash_bank.id.to_s
    if cash_bank.is_bank == true
      new_cash_bank_account.name = "Bank " + cash_bank.name.to_s
    else
      new_cash_bank_account.name = "Kas " + cash_bank.name.to_s
    end
    new_cash_bank_account.account_case = ACCOUNT_CASE[:ledger]
    new_cash_bank_account.parent_id = cash_bank_account.id
    new_cash_bank_account.normal_balance = cash_bank_account.normal_balance
    new_cash_bank_account.is_base_account = true
    new_cash_bank_account.save
    return new_cash_bank_account
  end
 
end



  
  
  
  
   
  