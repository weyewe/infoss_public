class ItemType < ActiveRecord::Base
  
  validates_presence_of :name 
  validates_uniqueness_of :name
  belongs_to :account 
  
  has_many :items 
  
  validate :valid_account
  
  def valid_account
    
    return if account_id.nil? 
    account = Account.find_by_id(account_id)
    if account.nil? 
      self.errors.add(:account_id, "Harus ada account_id")
      return self
    end
  end
  
  def self.active_objects
    self
  end
  
  




  def self.create_base_objects
    new_object = self.new
    new_object.name = BASE_ITEM_TYPE[:accessory]
    new_object.description = "ACC"
    new_object.account_id = Account.find_by_code(ACCOUNT_CODE[:bahan_baku_rollers][:code]).id
    new_object.is_legacy = true
    new_object.save
    new_object = self.new
    new_object.name = BASE_ITEM_TYPE[:adhesive_blanket]
    new_object.description = "ADB"
    new_object.account_id = Account.find_by_code(ACCOUNT_CODE[:bahan_baku_blanket][:code]).id 
    new_object.is_legacy = true
    new_object.save
    new_object = self.new
    new_object.name = BASE_ITEM_TYPE[:adhesive_roller]
    new_object.description = "ADR"
    new_object.account_id = Account.find_by_code(ACCOUNT_CODE[:bahan_baku_rollers][:code]).id 
    new_object.is_legacy = true
    new_object.save  
    new_object = self.new
    new_object.name = BASE_ITEM_TYPE[:bar]
    new_object.description = "BAR"
    new_object.account_id = Account.find_by_code(ACCOUNT_CODE[:bahan_baku_blanket][:code]).id 
    new_object.is_legacy = true
    new_object.save
    new_object = self.new
    new_object.name = BASE_ITEM_TYPE[:blanket]
    new_object.description = "BLK"
    new_object.account_id = Account.find_by_code(ACCOUNT_CODE[:persediaan_printing_blanket][:code]).id 
    new_object.is_legacy = true
    
    new_object.save
    new_object = self.new
    new_object.name = BASE_ITEM_TYPE[:roll_blanket]
    new_object.is_batched = true 
    new_object.description = "RBL"
    new_object.account_id = Account.find_by_code(ACCOUNT_CODE[:bahan_baku_blanket][:code]).id 
    new_object.is_legacy = true
    new_object.save
    new_object = self.new
    new_object.name = BASE_ITEM_TYPE[:chemical]
    new_object.description = "CHM"
    new_object.account_id = Account.find_by_code(ACCOUNT_CODE[:persediaan_printing_chemicals][:code]).id 
    new_object.is_legacy = true
    new_object.save  
    new_object = self.new
    new_object.name = BASE_ITEM_TYPE[:compound]
    new_object.is_batched = true 
    new_object.description = "CMP"
    new_object.account_id = Account.find_by_code(ACCOUNT_CODE[:bahan_baku_rollers][:code]).id 
    new_object.is_legacy = true
    new_object.save  
    new_object = self.new
    new_object.name = BASE_ITEM_TYPE[:core]
    new_object.description = "CRE"
    new_object.account_id = Account.find_by_code(ACCOUNT_CODE[:bahan_baku_rollers][:code]).id 
    new_object.is_legacy = true
    new_object.save  
    new_object = self.new
    new_object.name = BASE_ITEM_TYPE[:underpacking]
    new_object.description = "UPC"
    new_object.account_id = Account.find_by_code(ACCOUNT_CODE[:persediaan_barang_lainnya][:code]).id 
    new_object.is_legacy = true
    new_object.save  
    new_object = self.new
    new_object.name = BASE_ITEM_TYPE[:roller]
    new_object.description = "ROL"
    new_object.account_id = Account.find_by_code(ACCOUNT_CODE[:persediaan_printing_rollers][:code]).id 
    new_object.is_legacy = true
    new_object.save  
  end
  
  def self.create_object(params)
    new_object = self.new
    new_object.name = params[:name]
    new_object.sku = params[:sku]
    new_object.description = params[:description]
    new_object.account_id = params[:account_id]
    new_object.is_batched = params[:is_batched]
    new_object.save
    return new_object
  end
  
  def batched_stock_mutations
    item_id_list = self.items.map {|x| x.id } 
    
    BatchedStockMutation.where( :item_id => item_id_list )
  end
  
  def update_object(params)
    
    
    self.name = params[:name]
    self.description = params[:description]
    self.account_id = params[:account_id]
    self.is_batched  = params[:is_batched]
    
    if self.is_batched == false 
      if self.batch_stock_mutations.count != 0 
        self.errors.add(:is_batched, "Sudah ada batched item yang menggunakan tipe ini")
        return self 
      end
    end
    
    self.save
    return self
  end
  
  def delete_object
    if Item.where(:item_type_id => self.id).count > 0
      self.errors.add(:generic_errors, "ItemType sudah terpakai")
      return self
    end
    self.destroy
  end
  
end
