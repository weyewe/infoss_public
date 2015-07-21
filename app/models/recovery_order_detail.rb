class RecoveryOrderDetail < ActiveRecord::Base
  belongs_to :recovery_order
  belongs_to :roller_identification_form_detail
  belongs_to :roller_builder
  has_many  :recovery_accessory_details
  has_many :compound_usages 
  validates_presence_of :roller_identification_form_detail_id
  validates_presence_of :roller_builder_id
  validates_presence_of :core_type_case
  validate :valid_roller_identification_form_detail_id
  validate :valid_roller_builder_id
    
  def self.active_objects
    self
  end
  
  def active_children
    self.recovery_accessory_details 
  end 
  
  def active_compound_children
    self.compound_usages
  end 
    
  def valid_roller_identification_form_detail_id
    return if roller_identification_form_detail_id.nil?
    rifd = RollerIdentificationFormDetail.find_by_id roller_identification_form_detail_id
    if rifd.nil? 
      self.errors.add(:roller_identification_form_detail_id, "Harus ada RollerIdentificationFormDetail Id")
      return self 
    end
    itemcount = RecoveryOrderDetail.where(
      :roller_identification_form_detail_id => roller_identification_form_detail_id,
      :recovery_order_id => recovery_order_id,
      ).count  
    
    if self.persisted?
       if itemcount > 1
         self.errors.add(:roller_identification_form_detail_id, "Item sudah terpakai")
      return self 
       end
    else
       if itemcount > 0
         self.errors.add(:roller_identification_form_detail_id, "Item sudah terpakai")
      return self 
       end
    end
  end  
   
  def valid_roller_builder_id
    return if roller_builder_id.nil?
    rb = RollerBuilder.find_by_id roller_builder_id
    if rb.nil? 
      self.errors.add(:roller_builder_id, "Harus ada RollerBuilder Id")
      return self 
    end
  end
  
  def compound_under_layer
    Item.find_by_id(self.compound_under_layer_id)
  end
  
  def self.create_object(params)
    recovery_order = RecoveryOrder.find_by_id(params[:recovery_order_id])
    if not recovery_order.nil?
      if recovery_order.is_confirmed == true
        self.errors.add(:generic,"Sudah di confirm")
        return self
      end
    end
    new_object = self.new
    new_object.recovery_order_id = params[:recovery_order_id]
    new_object.roller_identification_form_detail_id = params[:roller_identification_form_detail_id]
    new_object.roller_builder_id = params[:roller_builder_id]
    new_object.core_type_case = params[:core_type_case]
    if new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    self.roller_identification_form_detail_id = params[:roller_identification_form_detail_id]
    self.roller_builder_id = params[:roller_builder_id]
    self.core_type_case = params[:core_type_case]
    if self.save
    end
    return self
  end
  
  def delete_object
    self.destroy
    return self
  end
  
  def update_batch_instance_amount( usage_amount ) 
    compound_batch_instance.update_amount(  usage_amount  ) 
  end
  
  
  def process_object(params)
    if self.is_finished?
      self.errors.add(:generic_errors, "Sudah di Finish. Silakan unfinish dan coba lagi")
      return self 
    end
    
    if self.is_rejected?
      self.errors.add(:generic_errors, "Sudah di Reject. Silakan unreject dan coba lagi")
      return self 
    end
    
    if params[:compound_under_layer_usage] <= BigDecimal("0")
      self.errors.add(:compound_under_layer_usage, "Harus lebih dari 0")
      return self 
    end
    # self.ensure_compound_batch_and_amount_is_valid_for_finish_or_reject
    return self if self.errors.size != 0 
     
    self.compound_usage = BigDecimal( params[:compound_usage] || '0')
    self.compound_under_layer_usage = BigDecimal( params[:compound_under_layer_usage] || '0')
    self.is_disassembled = params[:is_disassembled]
    self.is_stripped_and_glued = params[:is_stripped_and_glued]
    self.is_wrapped = params[:is_wrapped]
    self.is_vulcanized = params[:is_vulcanized]
    self.is_faced_off = params[:is_faced_off]
    self.is_conventional_grinded = params[:is_conventional_grinded]
    self.is_cnc_grinded = params[:is_cnc_grinded]
    self.is_polished_and_gc = params[:is_cnc_grinded]
    self.is_packaged = params[:is_cnc_grinded]
    self.compound_under_layer_id = params[:compound_under_layer_id]
    if self.save
    end
    return self
  end
  
    
  

  
  def finish_object(params)
    if self.is_rejected?   
      self.errors.add(:generic_errors, "Sudah reject")
      return self 
    end
    
    if self.is_finished?   
      self.errors.add(:generic_errors, "Sudah selesai")
      return self 
    end
    # self.ensure_compound_batch_and_amount_is_valid
    return self if self.errors.size != 0 
    
    
    
    self.is_finished = true
    self.finished_date = params[:finished_date]
    if self.save
      # create batch stock mutation
      # update amount in the batch_instance
            # create batch stock mutation
      # self.create_batch_stock_mutation( "FINISH")
      # self.update_batch_instance_amount( -1*self.compound_usage )
  

    
      
      calculate_total_cost
      # calculate service cost
      if self.recovery_order.roller_identification_form.is_in_house == false
        service_cost = ServiceCost.find_or_create_object(
          :roller_builder_id => self.roller_builder_id
          )
        service_cost.calculate_avg_price(:added_amount => 1 , :added_avg_price => self.total_cost)
      end
      
      update_recovery_order_amount_final(:recovery_order_id => self.recovery_order_id,:amount => 1)
      complete_recovery_order
      # deduce compound
      update_warehouse_item_amount(
        :item_id => self.roller_builder.compound_id,
        :mutation_date => self.finished_date,
        :case_addition =>ADJUSTMENT_STATUS[:deduction],
        :amount => self.compound_usage,
        )  
      # deduce compound_under_layer_usage
      if not self.compound_under_layer_id.nil?
      update_warehouse_item_amount(
        :item_id => self.compound_under_layer_id,
        :mutation_date => self.finished_date,
        :case_addition =>ADJUSTMENT_STATUS[:deduction],
        :amount => self.compound_under_layer_usage,
        ) 
      end
      # deduce core
      core_id = 0
      if self.roller_identification_form_detail.material_case == MATERIAL_CASE[:new]
        core_id = self.roller_identification_form_detail.core_builder.new_core_item.item.id
      elsif self.roller_identification_form_detail.material_case == MATERIAL_CASE[:used]
        core_id = self.roller_identification_form_detail.core_builder.used_core_item.item.id
      end
      update_warehouse_item_amount(
        :item_id => core_id,
        :mutation_date => self.finished_date,
        :case_addition =>ADJUSTMENT_STATUS[:deduction],
        :amount => self.compound_usage,
        )
        
      # add roller
      roller_id = 0
      if self.roller_identification_form_detail.material_case == MATERIAL_CASE[:new]
        roller_id = self.roller_builder.roller_new_core_item.item.id
      elsif self.roller_identification_form_detail.material_case == MATERIAL_CASE[:used]
        roller_id = self.roller_builder.roller_used_core_item.item.id
      end
      if self.recovery_order.roller_identification_form.is_in_house == true
        Item.find_by_id(roller_id).calculate_avg_price(
          :added_amount => 1,
          :added_avg_price => self.total_cost
          )
        update_warehouse_item_amount(
          :item_id => roller_id,
          :mutation_date => self.finished_date,
          :case_addition =>ADJUSTMENT_STATUS[:addition],
          :amount => 1,
          )
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
          :contact_id => self.recovery_order.roller_identification_form.contact_id,
          :customer_item_id => customer_item.id,
          :amount => 1,  
          :status => ADJUSTMENT_STATUS[:addition],  
          :mutation_date => self.finished_date ,  
          :warehouse_id => self.recovery_order.warehouse_id ,
          :warehouse_item_id => item_in_warehouse.id,
          :item_id => roller_id,
          :item_case => ITEM_CASE[:ready],
          :source_code => self.recovery_order.code
          ) 
        Item.find_by_id(roller_id).calculate_customer_avg_price(
          :added_amount => 1,
          :added_avg_price => self.total_cost
          )
        new_stock_mutation.stock_mutate_object
      end
      
      # deduce accessories  
      self.recovery_accessory_details.each do |rad|
        update_warehouse_item_amount(
          :item_id => rad.item_id,
          :mutation_date => self.finished_date,
          :case_addition =>ADJUSTMENT_STATUS[:deduction],
          :amount => rad.amount,
          )
      end
      AccountingService::CreateRecoveryOrderJournal.create_confirmation_journal(self)  
    end
  end
  
  def unfinish_object
    
    if self.is_rejected? 
      self.errors.add(:generic_errors, "Sudah reject")
      return self 
    end
    
    if not self.is_finished? 
      self.errors.add(:generic_errors, "Belum selesai")
      return self 
    end
    
    self.is_finished = false
    self.finished_date = nil
    if self.save
      # self.delete_batch_stock_mutation 
      # self.update_batch_instance_amount( self.compound_usage )
      
      complete_recovery_order
      total_cost = self.total_cost
      self.total_cost = 0
      self.accessories_cost = 0
      self.core_cost = 0
      self.compound_cost = 0
      
      # calculate service cost
      if self.recovery_order.roller_identification_form.is_in_house == false
      service_cost = ServiceCost.find_or_create_object(
        :roller_builder_id => self.roller_builder_id
        )
      service_cost.calculate_avg_price(:added_amount => -1 , :added_avg_price => total_cost)
      end
      
      update_recovery_order_amount_final(:recovery_order_id => self.recovery_order_id,:amount => -1)
      roller_id = 0
      if self.roller_identification_form_detail.material_case == MATERIAL_CASE[:new]
        roller_id = self.roller_builder.roller_new_core_item
        .item.id
      elsif self.roller_identification_form_detail.material_case == MATERIAL_CASE[:used]
        roller_id = self.roller_builder.roller_used_core_item
        .item.id
      end
      if self.recovery_order.roller_identification_form.is_in_house == true
        Item.find_by_id(roller_id).calculate_avg_price(
          :added_amount => -1,
          :added_avg_price => total_cost
          )
      else
        Item.find_by_id(roller_id).calculate_customer_avg_price(
          :added_amount => -1,
          :added_avg_price => total_cost
          )
        # new_stock_mutation.stock_mutate_object
      end
      
      # revese stock_mutation
      StockMutation.where(:source_class => self.class.to_s,:source_id => self.id).each do |sm|
        sm.reverse_stock_mutate_object
        sm.delete_object
      end
      CustomerStockMutation.where(:source_class => self.class.to_s,:source_id => self.id).each do |csm|
        csm.reverse_stock_mutate_object
        csm.delete_object
      end
      AccountingService::CreateRecoveryOrderJournal.undo_create_confirmation_journal(self)
    end
  end
  
   
  
  
  
  def reject_object(params)
    
    if self.is_rejected?  
      self.errors.add(:generic_errors, "Sudah reject")
      return self 
    end
    
    if self.is_finished?
      self.errors.add(:generic_errors, "Sudah finish")
      return self 
    end
    
    
    # self.ensure_compound_batch_and_amount_is_valid
    return self if self.errors.size != 0 
    
    self.is_rejected = true
    self.rejected_date = params[:rejected_date]
    if self.save

      # self.create_batch_stock_mutation( "REJECT")
      # self.update_batch_instance_amount( self.compound_usage )
      
      calculate_total_cost
      update_recovery_order_amount_rejected(:recovery_order_id => self.recovery_order_id,:amount => 1)
      complete_recovery_order 
      # deduce compound
      update_warehouse_item_amount(
        :item_id => self.roller_builder.compound_id,
        :mutation_date => self.rejected_date,
        :case_addition =>ADJUSTMENT_STATUS[:deduction],
        :amount => self.compound_usage,
        )  
      # deduce compound_under_layer_usage
      if not self.compound_under_layer_id.nil?
      update_warehouse_item_amount(
        :item_id => self.compound_under_layer_id,
        :mutation_date => self.rejected_date,
        :case_addition =>ADJUSTMENT_STATUS[:deduction],
        :amount => self.compound_under_layer_usage,
        ) 
      end
      # deduce core
      core_id = 0
      if self.roller_identification_form_detail.material_case == MATERIAL_CASE[:new]
        core_id = self.roller_identification_form_detail.core_builder.new_core_item.item.id
      elsif self.roller_identification_form_detail.material_case == MATERIAL_CASE[:used]
        core_id = self.roller_identification_form_detail.core_builder.used_core_item.item.id
      end
      update_warehouse_item_amount(
        :item_id => core_id,
        :mutation_date => self.rejected_date,
        :case_addition =>ADJUSTMENT_STATUS[:deduction],
        :amount => self.compound_usage,
        )
      AccountingService::CreateRecoveryOrderJournal.create_reject_journal(self)  
    end
    
  end
  
  def unreject_object
    if not self.is_rejected?
      self.errors.add(:generic_errors, "Belum reject")
      return self 
    end
    
    if self.is_finished?
      self.errors.add(:generic_errors, "Sudah finish")
      return self 
    end
    
    self.is_rejected = false
    self.rejected_date = nil
    if self.save
      # self.delete_batch_stock_mutation 
      # self.update_batch_instance_amount( self.compound_usage )
      
      self.total_cost = 0
      self.accessories_cost = 0
      self.core_cost = 0
      self.compound_cost = 0
      update_recovery_order_amount_rejected(:recovery_order_id => self.recovery_order_id,:amount => -1)
      complete_recovery_order
      # revese stock_mutation
      StockMutation.where(:source_class => self.class.to_s,:source_id => self.id).each do |sm|
        sm.reverse_stock_mutate_object
        sm.delete_object
      end
      AccountingService::CreateRecoveryOrderJournal.undo_create_confirmation_journal(self)
    end
  end
  
  def calculate_total_cost
    accessories_cost = 0
    self.total_cost = 0
    self.recovery_accessory_details.each do |rad|
      accessories_cost += rad.item.avg_price * rad.amount
    end
    self.accessories_cost = accessories_cost
    self.compound_cost = (self.roller_builder.compound.avg_price * self.compound_usage).round(2)
    
    if not self.compound_under_layer_id.nil?
      self.compound_cost += (self.compound_under_layer.avg_price * self.compound_under_layer_usage).round(2)
    end
    
    if self.recovery_order.roller_identification_form.is_in_house == true
      core_avg_price = 0
      if self.roller_identification_form_detail.material_case == MATERIAL_CASE[:new]
          core_avg_price = self.roller_identification_form_detail.core_builder.new_core_item.item.avg_price
        elsif self.roller_identification_form_detail.material_case == MATERIAL_CASE[:used]
          core_avg_price = self.roller_identification_form_detail.core_builder.used_core_item.item.avg_price
      end
      self.total_cost = core_avg_price + self.compound_cost + self.accessories_cost
    else
      self.total_cost = self.compound_cost + self.accessories_cost
      self.core_cost = 0
    end
    self.save
  end
  
  def update_recovery_order_amount_received(params)
    recovery_order = RecoveryOrder.find_by_id(params[:recovery_order_id])
    recovery_order.amount_received += params[:amount]
    recovery_order.save
  end
  
  def update_recovery_order_amount_rejected(params)
    recovery_order = RecoveryOrder.find_by_id(params[:recovery_order_id])
    recovery_order.amount_rejected += params[:amount]
    recovery_order.save
  end
  
  def update_recovery_order_amount_final(params)
    recovery_order = RecoveryOrder.find_by_id(params[:recovery_order_id])
    recovery_order.amount_final += params[:amount]
    recovery_order.save
  end
  
  def complete_recovery_order
    if RecoveryOrderDetail.where{
      (recovery_order_id.eq self.recovery_order_id) &
      ((is_finished.eq false) & (is_rejected.eq false)) 
      }.count == 0
      self.recovery_order.is_completed = true
    else
      self.recovery_order.is_completed = false
    end
    self.recovery_order.save
  end
  
  def update_warehouse_item_amount(params)
    item_in_warehouse = WarehouseItem.find_or_create_object(
      :warehouse_id => self.recovery_order.warehouse_id,
      :item_id => params[:item_id])      
    new_stock_mutation = StockMutation.create_object(
      :source_class => self.class.to_s, 
      :source_id => self.id ,  
      :amount => params[:amount],  
      :status => params[:case_addition],  
      :mutation_date => params[:mutation_date] ,  
      :warehouse_id => self.recovery_order.warehouse_id ,
      :warehouse_item_id => item_in_warehouse.id,
      :item_id =>params[:item_id],
      :item_case => ITEM_CASE[:ready],
      :source_code => self.recovery_order.code
      ) 
    new_stock_mutation.stock_mutate_object
  end
  
  
end
