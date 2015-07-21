class BlanketOrderDetail < ActiveRecord::Base
  belongs_to :blanket_order
  belongs_to :blanket
  validates_presence_of :blanket_order_id
  validates_presence_of :blanket_id
  
  has_many :roll_blanket_usages
  
  has_many :blanket_warehouse_mutation_details 
  
  validate :valid_blanket_order
  validate :valid_blanket
  
  validate :valid_quantity
  
  def self.active_objects
    self
  end
  
  def active_children
    self.roll_blanket_usages 
  end
  
  def valid_quantity
    return if not  quantity.present? 
    
    if quantity <= 0 
      self.errors.add(:quantity, "Harus ada. Tidak boleh 0 atau negative")
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
  
  def valid_blanket
    return if blanket_id.nil?
    
    bt = Blanket.find_by_id blanket_id
    
    if bt.nil? 
      self.errors.add(:blanket_id, "Harus ada Blanket id")
      return self 
    end
  end
  
  def batch_source
    BatchSource.where(
        :source_class => self.class.to_s,
        :source_id => self.id 
      ).first 
  end
  
  def self.create_object(params)
 
    
    new_object = self.new
     
    new_object.blanket_order_id = params[:blanket_order_id]
    new_object.blanket_id = params[:blanket_id]
    new_object.quantity = params[:quantity]
    
    blanket_order = BlanketOrder.find_by_id(params[:blanket_order_id])
    if not blanket_order.nil?
      if blanket_order.is_confirmed == true
        new_object.errors.add(:generic_errors,"Sudah di confirm")
        return new_object
      end
    end
    
  
    if new_object.save
      # add blanket_order.amount_received
      new_object.update_blanket_order_amount_received(
      :blanket_order_id => new_object.blanket_order_id,
      :amount => 1
      )
    end
    return new_object
  end
   
  def update_object(params)
    if self.blanket_order.is_confirmed == true
      self.errors.add(:generic,"Sudah di confirm")
      return self
    end
     
    
    self.blanket_id = params[:blanket_id]
    self.quantity = params[:quantity ]
    if self.save
    end
    return self
  end
  
  def delete_object
    if self.blanket_order.is_confirmed == true
      self.errors.add(:generic,"Sudah di confirm")
      return self
    end
    # reduce blanket_order.amount_received
    self.update_blanket_order_amount_received(
      :blanket_order_id => self.blanket_order_id,
      :amount => -1
      )
    self.destroy
  end
  
  def update_manufactured_item_average_price( is_cancelation ) 
    added_avg_price = self.bar_cost * self.finished_quantity  +  self.adhesive_cost   +   self.roll_blanket_cost  - self.roll_blanket_defect_cost 
    added_amount = self.finished_quantity
    
    multiplier = 1 
    multiplier = -1 if is_cancelation == true 
    
    self.blanket.item.calculate_avg_price(:added_amount => added_amount,:added_avg_price => multiplier * added_avg_price) 
  end
   
  
  def finish_object(params)
    if params[:finished_at].nil?
      self.errors.add(:finished_at,"Finished Date tidak boleh kosong")
      return self
    end
    if self.blanket_order.is_confirmed == false
      self.errors.add(:generic,"Belum di confirm")
      return self
    end
    if self.is_finished == true
      self.errors.add(:generic,"Sudah di finish")
      return self
    end 
    
    
    if not params[:roll_blanket_usage].present? or BigDecimal( params[:roll_blanket_usage] ) <=  BigDecimal("0")
      self.errors.add(:roll_blanket_usage,"Belum di isi")
      return self
    end
    
    if not params[:roll_blanket_defect].present? or params[:roll_blanket_defect].to_i <  BigDecimal("0")
      self.errors.add(:roll_blanket_defect,"Tidak boleh kurang dari 0")
      return self
    end
    
    if not  params[:finished_quantity].present? or params[:finished_quantity].to_i <= 0 
      self.errors.add(:finished_quantity, "Harus diisi")
      return self 
    end
    
    if not  params[:rejected_quantity].present? or params[:rejected_quantity].to_i < 0 
      self.errors.add(:rejected_quantity, "Tidak boleh negative")
      return self 
    end
    
    
    item = WarehouseItem.find_or_create_object(
      :warehouse_id => self.blanket_order.warehouse_id,
      :item_id => self.blanket.roll_blanket_item_id
      )
    if item.amount < BigDecimal( params[:roll_blanket_usage] ) 
      self.errors.add(:roll_blanket_defect,"Stock quantity Roll Blanket kurang dari #{params[:roll_blanket_usage]}")
      return self
    end
    
    if BigDecimal( params[:roll_blanket_usage])  < BigDecimal( params[:roll_blanket_defect] )
      self.errors.add(:roll_blanket_usage, "Tidak boleh lebih kecil dari jumlah yang defect")
      return self 
    end
    
  
    
    self.roll_blanket_usage = params[:roll_blanket_usage]
    self.roll_blanket_defect = params[:roll_blanket_defect]
    self.finished_quantity = params[:finished_quantity]
    self.rejected_quantity = params[:rejected_quantity]
    self.is_finished = true
    self.finished_at = params[:finished_at]
 
    if self.save
      
      BatchSource.create_object( 
          :item_id  => self.blanket.item.id,
          :status   =>  ADJUSTMENT_STATUS[:deduction], 
          :source_class => self.class.to_s, 
          :source_id => self.id , 
          :generated_date => self.finished_at , 
          :amount => self.roll_blanket_usage
        )
        
        
      self.undelivered_quantity = self.finished_quantity
      self.save 
      
      self.calculate_total_cost
      # add blanket_order_amount_final
      # self.update_blanket_order_amount_final(
      #   :blanket_order_id => self.blanket_order_id,
      #   :amount => 1
      #   )
      update_manufactured_item_average_price( false )
         
        
      update_warehouse_item_amount(
          :item_id => self.blanket.item.id,
          :mutation_date => self.finished_at,
          :case_addition =>ADJUSTMENT_STATUS[:addition],
          :amount => self.finished_quantity ,
          )  
      # deduce bar amount
      if self.blanket.has_left_bar == true
        update_warehouse_item_amount(
          :item_id => self.blanket.left_bar_item_id,
          :mutation_date => self.finished_at,
          :case_addition =>ADJUSTMENT_STATUS[:deduction],
          :amount => self.finished_quantity + self.rejected_quantity,
          )
      end  
      if self.blanket.has_right_bar == true
        update_warehouse_item_amount(
          :item_id => self.blanket.right_bar_item_id,
          :mutation_date => self.finished_at,
          :case_addition =>ADJUSTMENT_STATUS[:deduction],
          :amount => self.finished_quantity + self.rejected_quantity,
          )
      end  
      # deduce roll_blanket amount
      update_warehouse_item_amount(
        :item_id => self.blanket.roll_blanket_item_id,
        :mutation_date => self.finished_at,
        :case_addition =>ADJUSTMENT_STATUS[:deduction],
        :amount => self.roll_blanket_usage,
        )
      self.complete_blanket_order
      # create journal blanket order finish
      AccountingService::CreateBlanketOrderJournal.create_finish_journal(self) 
    end
  end
  
  def unfinish_object
    
    if self.blanket_order.is_confirmed == false
      self.errors.add(:generic,"Belum di confirm")
      return self
    end
    if self.is_finished == false
      self.errors.add(:generic,"Belum di finish")
      return self
    end
    
    if self.blanket_warehouse_mutation_details.count != 0 
      self.errors.add(:generic_errors, "Sudah ada perpindahan gudang ")
      return self 
    end
    
    if self.roll_blanket_usages.count != 0 
      self.errors.add(:generic_errors, "Sudah ada alokasi roll blanket")
      return self
    end

    # set all cost to 0
    self.is_finished = false
    self.finished_at = nil
 
    self.total_cost = 0
    self.adhesive_cost = 0
    self.roll_blanket_cost = 0
    self.roll_blanket_usage = 0
    self.roll_blanket_defect = 0
    # deduce blanket_order_amount_final
    # self.update_blanket_order_amount_final(
    #   :blanket_order_id => self.blanket_order_id,
    #   :amount => -1
    #   )
    
    if self.save
      
      BatchSource.where( 
          :item_id  => self.blanket.item.id, 
          :source_class => self.class.to_s, 
          :source_id => self.id  
        ).each {|x| x.destroy } 
        
        
      self.undelivered_quantity =  0
      self.save 
      
      self.complete_blanket_order
      # revese stock_mutation
      StockMutation.where(:source_class => self.class.to_s,:source_id => self.id).each do |sm|
        sm.reverse_stock_mutate_object
        sm.delete_object
      end
      AccountingService::CreateBlanketOrderJournal.undo_create_confirmation_journal(self)
    end

  end
  
  def update_undelivered_quantity( quantity ) 
    
    self.undelivered_quantity = self.undelivered_quantity + quantity  
    self.save  
  end
  
 
  
  
  def update_blanket_order_amount_received(params)
    blanket_order = BlanketOrder.find_by_id(params[:blanket_order_id])
    blanket_order.amount_received += params[:amount]
    blanket_order.save
  end
  
  def update_blanket_order_amount_rejected(params)
    blanket_order = BlanketOrder.find_by_id(params[:blanket_order_id])
    blanket_order.amount_rejected += params[:amount]
    blanket_order.save
  end
  
  def update_blanket_order_amount_final(params)
    blanket_order = BlanketOrder.find_by_id(params[:blanket_order_id])
    blanket_order.amount_final += params[:amount]
    blanket_order.save
  end
    
  def total_manufactured_quantity
    finished_quantity + rejected_quantity
  end
  
  
  def manufacturing_used_roll_blanket_cost
    roll_blanket_cost  - roll_blanket_defect_cost
  end
  
  def finished_quantity_ratio
    finished_quantity/total_manufactured_quantity.to_f
  end
  
  def rejected_quantity_ratio
    rejected_quantity/total_manufactured_quantity.to_f
  end
  
  def calculate_total_cost
    bar_cost = BigDecimal("0")
    roll_blanket_cost = BigDecimal("0")
    adhesive_cost = BigDecimal("0")
    total_cost = BigDecimal("0")
    
    roll_blanket_cost = (self.roll_blanket_usage * self.blanket.roll_blanket_item.avg_price).round(2)
    roll_blanket_defect_cost = (self.roll_blanket_defect * self.blanket.roll_blanket_item.avg_price).round(2)
    if self.blanket.has_left_bar == true
      bar_cost += self.blanket.left_bar_item.avg_price
    end
    
    if self.blanket.has_right_bar == true
      bar_cost += self.blanket.right_bar_item.avg_price
    end
    
    total_cost = roll_blanket_cost + adhesive_cost + bar_cost - roll_blanket_defect_cost
    self.adhesive_cost = adhesive_cost
    self.bar_cost = bar_cost
    self.roll_blanket_cost = roll_blanket_cost
    
    self.total_cost = total_cost
    
    self.roll_blanket_defect_cost = roll_blanket_defect_cost 
    
    self.save
  end
  
  def complete_blanket_order
    if BlanketOrderDetail.where{
      (blanket_order_id.eq self.blanket_order_id) &
      ((is_finished.eq false) & (is_rejected.eq false)) 
      }.count == 0
      self.blanket_order.is_completed = true
    else
      self.blanket_order.is_completed = false
    end
    
    self.blanket_order.save
  end
  
  def update_warehouse_item_amount(params)
    item_in_warehouse = WarehouseItem.find_or_create_object(
      :warehouse_id => self.blanket_order.warehouse_id,
      :item_id => params[:item_id])      
    new_stock_mutation = StockMutation.create_object(
      :source_class => self.class.to_s, 
      :source_id => self.id ,  
      :amount => params[:amount],  
      :status => params[:case_addition],  
      :mutation_date => params[:mutation_date] ,  
      :warehouse_id => self.blanket_order.warehouse_id ,
      :warehouse_item_id => item_in_warehouse.id,
      :item_id =>params[:item_id],
      :item_case => ITEM_CASE[:ready],
      :source_code => self.blanket_order.code
      ) 
    new_stock_mutation.stock_mutate_object
  end
  
end
