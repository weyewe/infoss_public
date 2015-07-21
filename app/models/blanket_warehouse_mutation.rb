class BlanketWarehouseMutation < ActiveRecord::Base
  belongs_to :blanket_order
  has_many :blanket_warehouse_mutation_details
  validates_presence_of :blanket_order_id
  validates_presence_of :warehouse_from_id
  validates_presence_of :warehouse_to_id
  validates_presence_of :mutation_date
  validate :valid_warehouse_from_id_and_warehouse_to_id
  validate :valid_blanket_order
  
  def self.active_objects
    self 
  end
  
  def active_children
    self.blanket_warehouse_mutation_details 
  end
  
  def valid_warehouse_from_id_and_warehouse_to_id
    return if warehouse_to_id.nil? or warehouse_from_id.nil?
    
    whfrom = Warehouse.find_by_id warehouse_from_id
    
    if whfrom.nil? 
      self.errors.add(:warehouse_from_id, "Harus ada warehouse id")
      return self 
    end
    
    whto = Warehouse.find_by_id warehouse_to_id
    
    if whto.nil? 
      self.errors.add(:warehouse_to_id, "Harus ada warehouse id")
      return self 
    end
  end
  
    
  def valid_blanket_order
    return if blanket_order_id.nil?
    bo = BlanketOrder.find_by_id blanket_order_id
    if bo.nil? 
      self.errors.add(:blanket_order_id, "Harus ada BlanketOrder id")
      return self 
    end
  end
    
  def warehouse_from
     Warehouse.find_by_id(self.warehouse_from_id)
  end
  
  def warehouse_to
     Warehouse.find_by_id(self.warehouse_to_id)
  end
  
  def self.create_object(params)
    new_object = self.new
    new_object.blanket_order_id = params[:blanket_order_id]
    new_object.warehouse_from_id = params[:warehouse_from_id]
    new_object.warehouse_to_id = params[:warehouse_to_id]
    new_object.mutation_date = params[:mutation_date] 
    if new_object.save
      new_object.code = "BWM-" + new_object.id.to_s  
      new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    
    if self.blanket_warehouse_mutation_details.count > 0
      self.errors.add(:generic_errors, "Memiliki detail")
      return self 
    end
    
    self.blanket_order_id = params[:blanket_order_id]
    self.warehouse_from_id = params[:warehouse_from_id]
    self.warehouse_to_id = params[:warehouse_to_id]
    self.mutation_date = params[:mutation_date] 
    return self
  end
  
  def delete_object
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    
    if self.blanket_warehouse_mutation_details.count > 0
      self.errors.add(:generic_errors, "Memiliki detail")
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
    
    if self.blanket_warehouse_mutation_details.count == 0
      self.errors.add(:generic_errors, "Tidak memiliki detail")
      return self 
    end
    
    self.blanket_warehouse_mutation_details.each do |bwmd|
      if bwmd.quantity > bwmd.blanket_order_detail.undelivered_quantity
        self.errors.add(:generic_errors, "Tidak cukup kuantitas untuk blanket #{bwmd.blanket_order_detail.blanket.name}")
        return self 
      end
    end
    
    self.is_confirmed = true
    self.confirmed_at = params[:confirmed_at]
    if self.save
      self.update_blanket_warehouse_item_confirm
    end
    return self
  end
  
  def unconfirm_object
    if not self.is_confirmed? 
      self.errors.add(:generic_errors, "Belum di konfirmasi")
      return self
    end
    
    self.blanket_warehouse_mutation_details.each do |bwmd|
      item_in_warehouse_to = WarehouseItem.find_or_create_object(
        :warehouse_id => self.warehouse_to_id,
        :item_id => bwmd.item_id)
      
      puts "item in warehouse_to : #{item_in_warehouse_to.amount.to_i }, while quantity returned: #{bwmd.quantity}"
      if item_in_warehouse_to.amount.to_i - bwmd.quantity < 0 
        self.errors.add(:generic_errors, "Tidak cukup item dari warehouse tujuan ke warehouse sumber")
        return self 
      end
    end
    
    
    
    self.is_confirmed = false
    self.confirmed_at = nil
    if self.save
      self.update_blanket_warehouse_item_unconfirm
    end
    return self
  end
  
 
  
  def update_blanket_warehouse_item_confirm
    self.blanket_warehouse_mutation_details.each do |bwmd|
      # deduce item_in_warehouse_from
      item_in_warehouse_from = WarehouseItem.find_or_create_object(
        :warehouse_id => self.warehouse_from_id,
        :item_id => bwmd.item_id)     
          
      new_stock_mutation_from = StockMutation.create_object(
        :source_class => bwmd.class.to_s, 
        :source_id => bwmd.id ,  
        :amount => bwmd.quantity,  
        :status => ADJUSTMENT_STATUS[:deduction],  
        :mutation_date => self.mutation_date ,  
        :warehouse_id => self.warehouse_from_id ,
        :warehouse_item_id => item_in_warehouse_from.id,
        :item_id => bwmd.item_id,
        :item_case => ITEM_CASE[:ready],
        :source_code => bwmd.code
        ) 
      new_stock_mutation_from.stock_mutate_object
      # add item_in_warehouse_to 
      item_in_warehouse_to = WarehouseItem.find_or_create_object(
        :warehouse_id => self.warehouse_to_id,
        :item_id => bwmd.item_id)
      new_stock_mutation_to = StockMutation.create_object(
        :source_class => bwmd.class.to_s, 
        :source_id => bwmd.id ,  
        :amount => bwmd.quantity,  
        :status => ADJUSTMENT_STATUS[:addition],  
        :mutation_date => self.mutation_date ,  
        :warehouse_id => self.warehouse_to_id ,
        :warehouse_item_id => item_in_warehouse_to.id,
        :item_id => bwmd.item_id,
        :item_case => ITEM_CASE[:ready],
        :source_code => bwmd.code
        ) 
      new_stock_mutation_to.stock_mutate_object
      
      bwmd.blanket_order_detail.update_undelivered_quantity( -1 * bwmd.quantity )
    end
  end
  
  def update_blanket_warehouse_item_unconfirm
    self.blanket_warehouse_mutation_details.each do |bwmd|
      #       Update Warehouse From
      item_in_warehouse_from = WarehouseItem.where(:warehouse_id => self.warehouse_from_id,:item_id => bwmd.item_id).first
      stock_mutation = StockMutation.where(
        :source_class => bwmd.class.to_s, 
        :source_id => bwmd.id,
        :warehouse_item_id => item_in_warehouse_from.id,
        :item_id => item_in_warehouse_from.item_id
        ).first
      stock_mutation.reverse_stock_mutate_object  
      stock_mutation.delete_object
#       Update Warehouse To
      item_in_warehouse_to = WarehouseItem.where(:warehouse_id => self.warehouse_to_id,:item_id => bwmd.item_id).first
      stock_mutation = StockMutation.where(
        :source_class => bwmd.class.to_s, 
        :source_id => bwmd.id,
        :warehouse_item_id => item_in_warehouse_to.id,
        :item_id => item_in_warehouse_to.item_id
        ).first
      stock_mutation.reverse_stock_mutate_object  
      stock_mutation.delete_object
      
      puts "gonna ask to update undelivered quantity by #{bwmd.quantity }"
      bwmd.blanket_order_detail.update_undelivered_quantity(  bwmd.quantity )
      
    end
  end
  
  
end
