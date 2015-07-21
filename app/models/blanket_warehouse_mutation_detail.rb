class BlanketWarehouseMutationDetail < ActiveRecord::Base
  belongs_to :blanket_warehouse_mutation
  belongs_to :blanket_order_detail
  belongs_to :item
  validates_presence_of :blanket_order_detail_id
  validates_presence_of :blanket_warehouse_mutation_id
  validate :valid_blanket_order_detail
  validate :valid_blanket_warehouse_mutation
  validate :valid_quantity_amount 
  
  
  def self.active_objects
    self 
  end
  
  def valid_quantity_amount
    return if not quantity.present? 
    
    if quantity <= 0 
      self.errors.add(:generic_errors, "Quantity tidak boleh 0 atau negative")
    end
    
    
  end
  
  def valid_blanket_warehouse_mutation
    return if blanket_warehouse_mutation_id.nil?
    bwm = BlanketWarehouseMutation.find_by_id blanket_warehouse_mutation_id
    if bwm.nil? 
      self.errors.add(:blanket_warehouse_mutation_id, "Harus ada BlanketWarehouseMutation id")
      return self 
    end
  end
  
  def valid_blanket_order_detail
    return if blanket_order_detail_id.nil?
    bod = BlanketOrderDetail.find_by_id blanket_order_detail_id
    if bod.nil? 
      self.errors.add(:blanket_order_detail_id, "Harus ada BlanketOrderDetail id")
      return self 
    end
    
    if bod.is_finished == false
      self.errors.add(:blanket_order_detail_id, "BlanketOrderDetail belum finish")
      return self 
    end
  end
  
  def self.create_object(params)
    blanket_warehouse_mutation = BlanketWarehouseMutation.find_by_id(params[:blanket_warehouse_mutation_id])
    if not blanket_warehouse_mutation.nil?
      if blanket_warehouse_mutation.is_confirmed?
        self.errors.add(:generic_errors, "Sudah di konfirmasi")
        return self 
      end
    end
    
    new_object = self.new
    new_object.blanket_warehouse_mutation_id = params[:blanket_warehouse_mutation_id]
    new_object.blanket_order_detail_id = params[:blanket_order_detail_id]
    new_object.quantity  = params[:quantity]
    if new_object.save
      new_object.item_id = new_object.blanket_order_detail.blanket.item.id
      new_object.code = "BWMD-" + new_object.id.to_s  
      new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    if self.blanket_warehouse_mutation.is_confirmed == true
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.blanket_order_detail_id = params[:blanket_order_detail_id]
    self.quantity  = params[:quantity]
    if new_object.save
      self.item_id = self.blanket_order_detail.blanket.item.id
    end
    return self
  end
  
  def delete_object
    self.destroy
    return self
  end  
end
