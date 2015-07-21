class RollerWarehouseMutation < ActiveRecord::Base
  belongs_to :recovery_order
  has_many :roller_warehouse_mutation_details
  validates_presence_of :recovery_order_id
  validates_presence_of :warehouse_from_id
  validates_presence_of :warehouse_to_id
  validates_presence_of :mutation_date
  validate :valid_warehouse_from_id_and_warehouse_to_id
  validate :valid_recovery_order
  
  def self.active_objects
    self 
  end
  
  def active_children
    self.roller_warehouse_mutation_details 
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
  
    
  def valid_recovery_order
    return if recovery_order_id.nil?
    bo = RecoveryOrder.find_by_id recovery_order_id
    if bo.nil? 
      self.errors.add(:recovery_order_id, "Harus ada RecoveryOrder id")
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
    new_object.recovery_order_id = params[:recovery_order_id]
    new_object.warehouse_from_id = params[:warehouse_from_id]
    new_object.warehouse_to_id = params[:warehouse_to_id]
    new_object.mutation_date = params[:mutation_date]
    new_object.amount = BigDecimal( params[:amount] || '0')
    if new_object.save
      new_object.code = "Cadj-" + new_object.id.to_s  
      new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    
    if self.roller_warehouse_mutation_details.count > 0
      self.errors.add(:generic_errors, "Memiliki detail")
      return self 
    end
    
    self.recovery_order_id = params[:recovery_order_id]
    self.warehouse_from_id = params[:warehouse_from_id]
    self.warehouse_to_id = params[:warehouse_to_id]
    self.mutation_date = params[:mutation_date]
    self.amount = BigDecimal( params[:amount] || '0')
    return self
  end
  
  def delete_object
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    
    if self.roller_warehouse_mutation_details.count > 0
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
    
    if self.roller_warehouse_mutation_details.count == 0
      self.errors.add(:generic_errors, "Tidak memiliki detail")
      return self 
    end
    
    self.is_confirmed = true
    self.confirmed_at = params[:confirmed_at]
    if self.save
      update_roller_warehouse_item_confirm
      
    end
    return self
  end
  
  def unconfirm_object
    if not self.is_confirmed? 
      self.errors.add(:generic_errors, "Belum di konfirmasi")
      return self
    end
    self.is_confirmed = false
    self.confirmed_at = nil
    if self.save
      update_roller_warehouse_item_unconfirm
    end
    return self
  end
  
  def update_roller_warehouse_item_confirm
    
    self.roller_warehouse_mutation_details.each do |rwmd|
      roller_id = 0
      if rwmd.recovery_order_detail.roller_identification_form_detail.material_case == MATERIAL_CASE[:new]
        roller_id = rwmd.recovery_order_detail.roller_builder.roller_new_core_item.item.id
      elsif rwmd.recovery_order_detail.roller_identification_form_detail.material_case == MATERIAL_CASE[:used]
        roller_id = rwmd.recovery_order_detail.roller_builder.roller_used_core_item.item.id
      end
      # deduce item_in_warehouse_from
      if self.recovery_order.roller_identification_form.is_in_house == true
        item_in_warehouse_from = WarehouseItem.find_or_create_object(
        :warehouse_id => self.warehouse_from_id,
        :item_id => roller_id)     
        new_stock_mutation_from = StockMutation.create_object(
          :source_class => self.class.to_s, 
          :source_id => self.id ,  
          :amount => self.amount,  
          :status => ADJUSTMENT_STATUS[:deduction],  
          :mutation_date => self.mutation_date ,  
          :warehouse_id => self.warehouse_from_id ,
          :warehouse_item_id => item_in_warehouse_from.id,
          :item_id => roller_id,
          :item_case => ITEM_CASE[:ready],
          :source_code => rwmd.code
          ) 
        new_stock_mutation_from.stock_mutate_object
        # add item_in_warehouse_to 
        item_in_warehouse_to = WarehouseItem.find_or_create_object(
          :warehouse_id => self.warehouse_to_id,
          :item_id => roller_id)
        new_stock_mutation_to = StockMutation.create_object(
          :source_class => self.class.to_s, 
          :source_id => self.id ,  
          :amount => self.amount,  
          :status => ADJUSTMENT_STATUS[:deduction],  
          :mutation_date => self.mutation_date ,  
          :warehouse_id => self.warehouse_to_id ,
          :warehouse_item_id => item_in_warehouse_to.id,
          :item_id => roller_id,
          :item_case => ITEM_CASE[:ready],
          :source_code => rwmd.code
          ) 
        new_stock_mutation_to.stock_mutate_object
      else
        item_in_warehouse = WarehouseItem.find_or_create_object(
          :warehouse_id => self.recovery_order.warehouse_id,
          :item_id => roller_id)
        customer_item = CustomerItem.find_or_create_object(
          :contact_id => self.recovery_order.roller_identification_form.contact_id,
          :warehouse_item_id => item_in_warehouse.id
          )
        new_stock_mutation = CustomerStockMutation.create_object(
          :source_class => self.class.to_s, 
          :source_id => self.id ,  
          :contact_id => self.contact_id,
          :customer_item_id => customer_item.id,
          :amount => 1,  
          :status => ADJUSTMENT_STATUS[:addition],  
          :mutation_date => self.mutation_date ,  
          :warehouse_id => self.warehouse_id ,
          :warehouse_item_id => item_in_warehouse.id,
          :item_id => roller_id,
          :item_case => ITEM_CASE[:ready],
          :source_code => self.code
          ) 
        new_stock_mutation.stock_mutate_object
      end
      rwmd.recovery_order_detail.roller_identification_form_detail.is_delivered = true
      rwmd.recovery_order_detail.roller_identification_form_detail.save
    end
      complete_roller_identification_form
  end
  
  def update_roller_warehouse_item_unconfirm
    StockMutation.where(:source_class => self.class.to_s,:source_id => self.id).each do |sm|
      sm.reverse_stock_mutate_object
      sm.delete_object
    end
    CustomerStockMutation.where(:source_class => self.class.to_s,:source_id => self.id).each do |csm|
      csm.reverse_stock_mutate_object
      csm.delete_object
    end
    self.roller_warehouse_mutation_details.each do |rwmd|
      rwmd.recovery_order_detail.roller_identification_form_detail.is_delivered = false
      rwmd.recovery_order_detail.roller_identification_form_detail.save
    end
    complete_roller_identification_form
  end
  
  def complete_roller_identification_form
    if self.recovery_order.roller_identification_form.roller_identification_form_details.where(
      :is_delivered => true).count > 0
      self.recovery_order.roller_identification_form.is_completed = true
    else
      self.recovery_order.roller_identification_form.is_completed = false
    end
    self.recovery_order.roller_identification_form.save
  end
  
end
