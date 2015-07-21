class WarehouseMutation < ActiveRecord::Base
  has_many :warehouse_mutation_details
  validates_presence_of :warehouse_from_id
  validates_presence_of :warehouse_to_id
  validates_presence_of :mutation_date
  
  validate :valid_warehouse_from_id_and_warehouse_to_id
  
  def self.active_objects
    self
  end
  
  def active_children
    self.warehouse_mutation_details
  end
  
  def valid_warehouse_from_id_and_warehouse_to_id
    return if  warehouse_to_id.nil? or warehouse_from_id.nil?
    
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
  
  def warehouse_from
    Warehouse.find_by_id(self.warehouse_from_id)
  end
  
  def warehouse_to
    Warehouse.find_by_id(self.warehouse_to_id) 
  end
  
  def self.create_object( params )
    new_object = self.new
    new_object.warehouse_from_id = params[:warehouse_from_id]
    new_object.warehouse_to_id = params[:warehouse_to_id]
    new_object.mutation_date = params[:mutation_date]
    new_object.save
    new_object.code = "WhM-" + new_object.id.to_s  
    new_object.save
    
    return new_object
  end
  
  def update_object( params ) 
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    if self.warehouse_mutation_details.count > 0
      self.errors.add(:generic_errors, "Sudah memiliki detail")
      return self 
    end
    self.warehouse_from_id = params[:warehouse_from_id]
    self.warehouse_to_id = params[:warehouse_to_id]
    self.mutation_date = params[:mutation_date]
    self.save 
    return self
  end
  
  def update_total(amount)
    self.total = amount
    self.save
  end
    
  def validate_warehouse_item_amount
    self.warehouse_mutation_details.each do |wmd|
      item_in_warehouse = WarehouseItem.where(:warehouse_id => self.warehouse_from_id,:item_id => wmd.item_id).first
      if not item_in_warehouse.nil?
        if wmd.amount > item_in_warehouse.amount 
          self.errors.add(:generic_errors, "Amount Item di warehouse kurang")
          return self 
        end
      else
        self.errors.add(:generic_errors, "Amount Item di warehouse kurang")
        return self 
      end
    end
  end
  
  def update_warehouse_item_confirm
    self.warehouse_mutation_details.each do |wmd|
#       Update Warehouse From
      item_in_warehouse_from = WarehouseItem.find_or_create_object(:warehouse_id => self.warehouse_from_id,:item_id => wmd.item_id)
      new_stock_mutation = StockMutation.create_object(
        :source_class => self.class.to_s, 
        :source_id => self.id ,  
        :amount => wmd.amount ,  
        :status => ADJUSTMENT_STATUS[:deduction],  
        :mutation_date => self.mutation_date ,  
        :warehouse_id => self.warehouse_from_id ,
        :warehouse_item_id => item_in_warehouse_from.id,
        :item_id => wmd.item_id,
        :item_case => ITEM_CASE[:ready],
        :source_code => self.code
        ) 
      new_stock_mutation.stock_mutate_object
     
#       Update Warehouse To
      item_in_warehouse_to = WarehouseItem.find_or_create_object(:warehouse_id => self.warehouse_to_id,:item_id => wmd.item_id)
   
      new_stock_mutation = StockMutation.create_object(
        :source_class => self.class.to_s, 
        :source_id => self.id ,  
        :amount => wmd.amount ,  
        :status => ADJUSTMENT_STATUS[:addition],  
        :mutation_date => self.mutation_date ,  
        :warehouse_id => self.warehouse_to_id ,
        :warehouse_item_id => item_in_warehouse_to.id,
        :item_id => wmd.item_id,
        :item_case => ITEM_CASE[:ready],
        :source_code => self.code
        ) 
       new_stock_mutation.stock_mutate_object
 
    end
  end
  
  def update_warehouse_item_unconfirm
    self.warehouse_mutation_details.each do |wmd|
      #       Update Warehouse From
      item_in_warehouse_from = WarehouseItem.where(:warehouse_id => self.warehouse_from_id,:item_id => wmd.item_id).first
      stock_mutation = StockMutation.where(
        :source_class => self.class.to_s, 
        :source_id => self.id,
        :warehouse_item_id => item_in_warehouse_from.id,
        :item_id => item_in_warehouse_from.item_id
        ).first
      stock_mutation.reverse_stock_mutate_object  
      stock_mutation.delete_object
#       Update Warehouse To
      item_in_warehouse_to = WarehouseItem.where(:warehouse_id => self.warehouse_to_id,:item_id => wmd.item_id).first
      stock_mutation = StockMutation.where(
        :source_class => self.class.to_s, 
        :source_id => self.id,
        :warehouse_item_id => item_in_warehouse_to.id,
        :item_id => item_in_warehouse_to.item_id
        ).first
      stock_mutation.reverse_stock_mutate_object  
      stock_mutation.delete_object
    end
  end
    
  def confirm_object( params )
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    
    if params[:confirmed_at].nil?
      self.errors.add(:generic_errors, "Harus ada tanggal konfirmasi")
      return self 
    end
    
    if self.warehouse_mutation_details.count == 0
      self.errors.add(:generic_errors, "Tidak memiliki detail")
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
  
  def generate_stock_mutation(params)
    StockMutation.create_object(
      :source_class => self.class.to_s, 
      :source_id => self.id ,  
      :amount => params[:amount] ,  
      :status => params[:status],  
      :mutation_date => self.mutation_date ,  
      :warehouse_id => params[:warehouse_id],
      :warehouse_item_id => params[:item_id],
      :source_code => self.code
       ) 
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
    self.warehouse_mutation_details.each do |wmd|
      item_in_warehouse_to = WarehouseItem.where(:warehouse_id => self.warehouse_to_id,:item_id => wmd.item_id).first
      if not item_in_warehouse_to.nil?
        if wmd.amount > item_in_warehouse_to.amount 
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
    
    if self.warehouse_mutation_details.count > 0
      self.errors.add(:generic_errors, "Sudah memiliki detail")
      return self 
    end
    
    self.destroy
    return self
  end
  
  
end
