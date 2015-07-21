class WarehouseMutationDetail < ActiveRecord::Base
  
  validates_presence_of :item_id
 
  validate :valid_warehouse_mutation
  validate :valid_item
  validate :valid_amount
  belongs_to :warehouse_mutation
  belongs_to :item
  
  def self.active_objects
    self
  end
     
  
  def valid_amount
    return if amount.nil?
    if amount <= BigDecimal("0")
      self.errors.add(:amount, "Harus lebih besar dari 0")
      return self
    end
  end
  
  def valid_warehouse_mutation
    return if  warehouse_mutation_id.nil?
    wm = WarehouseMutation.find_by_id warehouse_mutation_id
    if wm.nil? 
      self.errors.add(:warehouse_mutation_id, "Harus ada warehouse_mutation_id")
      return self 
    end
  end 
    
  def valid_item
    return if  item_id.nil?
    item = Item.find_by_id item_id
    if item.nil? 
      self.errors.add(:item_id, "Harus ada Item_Id")
      return self 
    end
    
    itemcount = WarehouseMutationDetail.where(
      :item_id => item_id,
      :warehouse_mutation_id => warehouse_mutation_id,
      ).count  
    
    if self.persisted?
       if itemcount > 1
         self.errors.add(:item_id, "Item sudah terpakai")
      return self 
       end
    else
       if itemcount > 0
         self.errors.add(:item_id, "Item sudah terpakai")
      return self 
       end
    end
  end 
  
  
  def self.create_object(params)
    new_object = self.new
    warehouse_mutation = WarehouseMutation.find_by_id(params[:warehouse_mutation_id])
    if not warehouse_mutation.nil?
      if warehouse_mutation.is_confirmed?
        new_object.errors.add(:generic_errors, "Sudah di konfirmasi")
        return new_object 
      end
    end
    new_object.warehouse_mutation_id = params[:warehouse_mutation_id]
    new_object.item_id = params[:item_id]
    new_object.amount = params[:amount]
    if new_object.save
      new_object.code = "WmD-" + new_object.id.to_s  
    end
    return new_object
  end
  
  def update_object(params)
    if self.warehouse_mutation.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.item_id = params[:item_id]
    self.amount = params[:amount]
    return self
  end
  
  def delete_object
    if self.warehouse_mutation.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.destroy
    return self
  end
  
  
end
