class CustomerStockAdjustment < ActiveRecord::Base
    
  belongs_to :warehouse
  belongs_to :contact
  has_many :customer_stock_adjustment_details
  validates_presence_of :contact_id
  validates_presence_of :warehouse_id
  validates_presence_of :adjustment_date
  
  validate :valid_contact
  validate :valid_warehouse
  
  def self.active_objects
    self 
  end
  
  def active_children
    self.customer_stock_adjustment_details 
  end
  def valid_contact
    return if contact_id.nil?
    
    con = Contact.find_by_id contact_id
    
    if con.nil? 
      self.errors.add(:warehouse_id, "Harus ada contact id")
      return self 
    end
  end
  
  
  def valid_warehouse
    return if  warehouse_id.nil?
    
    wh = Warehouse.find_by_id warehouse_id
    
    if wh.nil? 
      self.errors.add(:warehouse_id, "Harus ada warehouse id")
      return self 
    end
  end

  
  def valid_amount
    return if amount.nil? 
    
    if amount <= BigDecimal("0")
      self.errors.add(:amount, "Harus lebih besar dari 0")
      return self
    end
  end
  
  
  
  def self.create_object( params )
    new_object = self.new
    new_object.contact_id = params[:contact_id]
    new_object.warehouse_id = params[:warehouse_id]
    new_object.adjustment_date = params[:adjustment_date]
    new_object.description = params[:description]
    if new_object.save
      new_object.code = "Cadj-" + new_object.id.to_s  
      new_object.save
    end
    return new_object
  end
  
  def update_object( params ) 
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    if self.customer_stock_adjustment_details.count > 0
      self.errors.add(:generic_errors, "Sudah memiliki detail")
      return self 
    end
    self.contact_id = params[:contact_id]
    self.warehouse_id = params[:warehouse_id]
    self.adjustment_date = params[:adjustment_date]
    self.description = params[:description]
    self.save 
    return self
  end
  
  def update_total(amount)
    self.total = amount
    self.save
  end
    
  def validate_warehouse_item_amount
    self.customer_stock_adjustment_details.each do |csad|
      item_in_warehouse = WarehouseItem.find_or_create_object(:warehouse_id => self.warehouse_id,:item_id => csad.item_id)
      customer_item = CustomerItem.find_or_create_object(
        :contact_id => self.contact_id,
        :warehouse_item_id => item_in_warehouse.id
        )
      if not customer_item.nil?
        if csad.status == ADJUSTMENT_STATUS[:deduction] and csad.amount > customer_item.amount 
          self.errors.add(:generic_errors, "Amount Item di warehouse kurang")
          return self 
        end
      else
        if csad.status == ADJUSTMENT_STATUS[:deduction]
           self.errors.add(:generic_errors, "Amount Item di warehouse kurang")
           return self 
        end
      end
    end
  end
  
  def update_warehouse_item_confirm
    self.customer_stock_adjustment_details.each do |csad|
      csad.item.calculate_customer_avg_price(:added_amount => csad.amount,:added_avg_price => csad.price)
      item_in_warehouse = WarehouseItem.find_or_create_object(:warehouse_id => self.warehouse_id,:item_id => csad.item_id)      
      customer_item = CustomerItem.find_or_create_object(
        :contact_id => self.contact_id,
        :warehouse_item_id => item_in_warehouse.id
        )
      new_stock_mutation = CustomerStockMutation.create_object(
        :source_class => self.class.to_s, 
        :source_id => self.id ,  
        :contact_id => self.contact_id,
        :customer_item_id => customer_item.id,
        :amount => csad.amount,  
        :status => csad.status,  
        :mutation_date => self.adjustment_date ,  
        :warehouse_id => self.warehouse_id ,
        :warehouse_item_id => item_in_warehouse.id,
        :item_id => csad.item_id,
        :item_case => ITEM_CASE[:ready],
        :source_code => self.code
        ) 
      new_stock_mutation.stock_mutate_object
    end
  end
  
  def update_warehouse_item_unconfirm
    self.customer_stock_adjustment_details.each do |csad|
      csad.item.calculate_customer_avg_price(:added_amount => (csad.amount * -1),:added_avg_price => csad.price)
      item_in_warehouse = WarehouseItem.find_or_create_object(:warehouse_id => self.warehouse_id,:item_id => csad.item_id)
      customer_item = CustomerItem.find_or_create_object(
        :contact_id => self.contact_id,
        :warehouse_item_id => item_in_warehouse.id
        )
      customer_stock_mutation = CustomerStockMutation.where(
        :source_class => self.class.to_s, 
        :source_id => self.id,
        :contact_id => self.contact_id,
        :customer_item_id => customer_item.id,
        :warehouse_item_id => item_in_warehouse.id,
        :item_id => item_in_warehouse.item_id
        ).first
      customer_stock_mutation.reverse_stock_mutate_object  
      customer_stock_mutation.delete_object
    end
  end
  
    
  def confirm_object( params )  
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    
    if self.customer_stock_adjustment_details.count == 0
      self.errors.add(:generic_errors, "Tidak memiliki detail")
      return self 
    end
    
    if params[:confirmed_at].nil?
      self.errors.add(:generic_errors, "Harus ada tanggal konfirmasi")
      return self 
    end
    
    self.validate_warehouse_item_amount
    return self if self.errors.size != 0 
   
    self.confirmed_at = params[:confirmed_at]
    self.is_confirmed = true  
    
    if self.save 
      self.update_warehouse_item_confirm    
    end
    
    return self 
  end
  
  def destroy_stock_mutation
    StockMutation.where(
        :source_class => self.class.to_s, 
        :source_id => self.id
      ).each {|x| x.delete_object  }
  end
  
  def unconfirm_object
    if not self.is_confirmed?
      self.errors.add(:generic_errors, "belum di konfirmasi")
      return self 
    end
    
#   validate remaining amount in warehouse_item
    self.customer_stock_adjustment_details.each do |csad|
      
      item_in_warehouse = WarehouseItem.find_or_create_object(:warehouse_id => self.warehouse_id,:item_id => csad.item_id)
      customer_item = CustomerItem.find_or_create_object(
        :contact_id => self.contact_id,
        :warehouse_item_id => item_in_warehouse.id
        )
      if not item_in_warehouse.nil?
        if csad.status == ADJUSTMENT_STATUS[:addition] and csad.amount > customer_item.amount 
          self.errors.add(:generic_errors, "Amount Item di warehouse kurang")
          return self 
        end
      end
    end
    
    self.is_confirmed = false
    self.confirmed_at = nil 
    if self.save
      self.update_warehouse_item_unconfirm
    end
    return self
  end
   
  
  def delete_object
    if self.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    
    if self.customer_stock_adjustment_details.count > 0
      self.errors.add(:generic_errors, "Sudah memiliki detail")
      return self 
    end
    
    self.destroy
    return self
  end
  
  
  
    
    
end
