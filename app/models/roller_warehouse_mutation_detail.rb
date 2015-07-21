class RollerWarehouseMutationDetail < ActiveRecord::Base
  belongs_to :roller_warehouse_mutation
  belongs_to :recovery_order_detail
  belongs_to :item
  validates_presence_of :recovery_order_detail_id
  validates_presence_of :roller_warehouse_mutation_id
  validate :valid_recovery_order_detail
  validate :valid_roller_warehouse_mutation
  
  def self.active_objects
    self 
  end
  
  def valid_roller_warehouse_mutation
    return if roller_warehouse_mutation_id.nil?
    rwm = RollerWarehouseMutation.find_by_id roller_warehouse_mutation_id
    if rwm.nil? 
      self.errors.add(:roller_warehouse_mutation_id, "Harus ada RollerWarehouseMutation id")
      return self 
    end
  end
  
  def valid_recovery_order_detail
    return if recovery_order_detail_id.nil?
    rod = RecoveryOrderDetail.find_by_id recovery_order_detail_id
    if rod.nil? 
      self.errors.add(:recovery_order_detail_id, "Harus ada RecoveryOrderDetail id")
      return self 
    end
    
    if rod.is_finished == false
      self.errors.add(:recovery_order_detail_id, "RecoveryOrderDetail belum finish")
      return self 
    end
  end
  
  def self.create_object(params)
    roller_warehouse_mutation = RollerWarehouseMutation.find_by_id(params[:roller_warehouse_mutation_id])
    if not roller_warehouse_mutation.nil?
      if roller_warehouse_mutation.is_confirmed?
        self.errors.add(:generic_errors, "Sudah di konfirmasi")
        return self 
      end
    end
    
    new_object = self.new
    new_object.roller_warehouse_mutation_id = params[:roller_warehouse_mutation_id]
    new_object.recovery_order_detail_id = params[:recovery_order_detail_id]
    if new_object.save
      item_id = 0 
      if new_object.recovery_order_detail.roller_identification_form_detail.material_case == MATERIAL_CASE[:new] 
        item_id = new_object.recovery_order_detail.roller_builder.roller_new_core_item.id
      elsif new_object.recovery_order_detail.roller_identification_form_detail.material_case == MATERIAL_CASE[:used]
        item_id = new_object.recovery_order_detail.roller_builder.roller_used_core_item.id
      end
      new_object.item_id = item_id
      new_object.code = "Cadj-" + new_object.id.to_s  
      new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    if self.roller_warehouse_mutation.is_confirmed == true
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.recovery_order_detail_id = params[:recovery_order_detail_id]
    if self.save
      item_id = 0 
      if self.recovery_order_detail.roller_identification_form_detail.material_case == MATERIAL_CASE[:new] 
        item_id = self.recovery_order_detail.roller_builder.roller_new_core_item.id
      elsif self.recovery_order_detail.roller_identification_form_detail.material_case == MATERIAL_CASE[:used]
        item_id = self.recovery_order_detail.roller_builder.roller_used_core_item.id
      end
      self.item_id = item_id
    end
    return self
  end
  
  def delete_object
    self.destroy
    return self
  end   
    
    
end
