class Item < ActiveRecord::Base
  actable
  belongs_to :item_type
  belongs_to :exchange
  belongs_to :uom 
  belongs_to :sub_type
  has_many :stock_mutations 
  has_many :batch_stock_mutations
  has_many :batch_instances
  
   
  validates_presence_of :sku
  validates_uniqueness_of :sku
  validates_presence_of :name
  validates_presence_of :item_type_id
  validates_presence_of :exchange_id
  
  validate :valid_uom_id
  validate :valid_item_type_id
  validate :valid_exchange_id
  validate :valid_selling_price_and_price_list_and_minimum_amount
  
  def valid_uom_id
    return if uom_id.nil? 
    uom = Uom.find_by_id(uom_id)
    if uom.nil? 
      self.errors.add(:uom_id, "Harus ada uom_id")
      return self
    end
  end
  
  def is_batched?
    self.item_type.is_batched? 
  end
  
  def self.compounds
    self.joins(:item_type).where{(item_type.name.eq "Compound")}
    
  end
  
  def self.adhesive_rollers
    self.joins(:item_type).where{(item_type.name.eq "AdhesiveRoller")}
  end
  
  def self.adhesive_blankets
    self.joins(:item_type).where{(item_type.name.eq "AdhesiveBlanket")}
  end
  
  def self.bars
    self.joins(:item_type).where{(item_type.name.eq "Bar")}
  end
  
  def self.roll_blankets
    self.joins(:item_type).where{(item_type.name.eq "RollBlanket")}
  end
  
  def update_amount(amount)
    self.amount += amount
    self.save
  end
  
  def update_pending_receival(amount)
    self.pending_receival += amount
    self.save
  end
  
  def update_pending_delivery(amount)
    self.pending_delivery += amount
    self.save
  end
  
  def update_virtual(amount)
    self.virtual += amount
    self.save
  end
  
  def update_customer_amount(amount)
    self.customer_amount += amount
    self.save
  end
  
  def calculate_avg_price(params)
    original_amount = self.amount + self.virtual
    original_avg_price = self.avg_price
    avg_price = 0 
    if (original_amount + params[:added_amount]) > 0 
      a = original_amount * original_avg_price
      b = params[:added_amount] * params[:added_avg_price]
      c = original_amount + params[:added_amount]
      avg_price = (
          (a+b)/c
        )
    end
    self.avg_price = avg_price
    self.save  
    return self
  end
  
  def calculate_customer_avg_price(params)
    original_amount = self.amount + self.virtual
    original_avg_price = self.customer_avg_price
    avg_price = 0 
    if (original_amount + params[:added_amount]) > 0 
      a = original_amount * original_avg_price
      b = params[:added_amount] * params[:added_avg_price]
      c = original_amount + params[:added_amount]
      avg_price = (
          (a+b)/c
        )
    end
    self.customer_avg_price = avg_price
    self.save  
    return self
  end
  
  def valid_item_type_id
    return if item_type_id.nil?
    item_type = ItemType.find_by_id(item_type_id)
    if item_type.nil? 
      self.errors.add(:item_type_id, "Harus ada item_type_id")
      return self
    end
  end
  
  def valid_exchange_id
    return if exchange_id.nil? 
    exchange = Exchange.find_by_id(exchange_id)
    if exchange.nil? 
      self.errors.add(:exchange_id, "Harus ada currency_id")
      return self
    end
  end
  
  def valid_selling_price_and_price_list_and_minimum_amount
    return if selling_price.nil? or price_list.nil? or minimum_amount.nil?
    
    if selling_price <= BigDecimal("0")
      self.errors.add(:selling_price, "Harus lebih besar dari 0")
      return self
    end
    
    if price_list <= BigDecimal("0")
      self.errors.add(:price_list, "Harus lebih besar dari 0")
      return self
    end
    
    if minimum_amount <= BigDecimal("0")
      self.errors.add(:minimum_amount, "Harus lebih besar dari 0")
      return self
    end
  end
  
  def self.active_objects
    self
  end
  
  def self.create_object(params)
    new_object = self.new
    new_object.item_type_id = params[:item_type_id]
    new_object.sub_type_id = params[:sub_type_id]
    new_object.sku = params[:sku]
    new_object.name = params[:name]
    new_object.description = params[:description]
    new_object.is_tradeable = params[:is_tradeable]
    new_object.uom_id = params[:uom_id]
#     new_object.amount = params[:amount]
    new_object.minimum_amount = BigDecimal( params[:minimum_amount] || '0')  
    new_object.selling_price = BigDecimal( params[:selling_price] || '0')  
    new_object.price_list = BigDecimal( params[:price_list] || '0')  
    new_object.exchange_id = params[:exchange_id]
    new_object.save
    return new_object
  end
  
  def update_object(params)
    self.name = params[:name]
    self.item_type_id = params[:item_type_id]
    self.sub_type_id = params[:sub_type_id]
    self.sku = params[:sku]
    self.name = params[:name]
    self.description = params[:description]
    self.is_tradeable = params[:is_tradeable]
    self.uom_id = params[:uom_id]
#     self.amount = params[:amount]
    self.minimum_amount =  BigDecimal( params[:minimum_amount] || '0') 
    self.selling_price =  BigDecimal( params[:selling_price] || '0') 
    self.exchange_id = params[:exchange_id]
    self.price_list =  BigDecimal( params[:price_list] || '0') 
    
    if self.batch_stock_mutations.count != 0 
      self.errors.add(:item_type_id, "Tidak bisa mengubah item type karena sudah ada batch stock mutation")
      return self 
    end
    
    self.save
    return self
  end
  
  def delete_object
    if self.item_type.is_legacy == true
      self.errors.add(:generic_errors, "Tidak bisa menghapus legacy Item")
      return self
    end
    if Blanket.where(:roll_blanket_item_id => self.id).count > 0 
      self.errors.add(:generic_errors, "Item sudah terpakai")
      return self
    end
    if Blanket.where(:left_bar_item_id => self.id).count > 0 
      self.errors.add(:generic_errors, "Item sudah terpakai")
      return self
    end
    if Blanket.where(:right_bar_item_id => self.id).count > 0 
      self.errors.add(:generic_errors, "Item sudah terpakai")
      return self
    end
    if Blanket.where(:adhesive_id => self.id).count > 0 
      self.errors.add(:generic_errors, "Item sudah terpakai")
      return self
    end 
    if Blanket.where(:adhesive2_id => self.id).count > 0 
      self.errors.add(:generic_errors, "Item sudah terpakai")
      return self
    end 
    if StockMutation.where(:item_id => self.id).count > 0 
      self.errors.add(:generic_errors, "Item sudah terpakai")
      return self
    end
    if PurchaseOrderDetail.where(:item_id => self.id).count > 0
      self.errors.add(:generic_errors, "Item sudah terpakai")
      return self
    end
    if SalesOrderDetail.where(:item_id => self.id).count > 0
      self.errors.add(:generic_errors, "Item sudah terpakai")
      return self
    end
    if StockAdjustmentDetail.where(:item_id => self.id).count > 0
      self.errors.add(:generic_errors, "Item sudah terpakai")
      return self
    end
    item_id = self.id
    if WarehouseItem.where{
      (item_id == item_id) && 
      (amount.gt 0)
    }.count > 0
      self.errors.add(:generic_errors, "Item diwarehouse harus 0")
      return self
    end
    self.destroy
  end
  
  
end
