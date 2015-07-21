class BlendingWorkOrder < ActiveRecord::Base
    belongs_to :blending_recipe
    belongs_to :warehouse
    validates_presence_of :warehouse_id
    validates_presence_of :blending_recipe_id
    validates_presence_of :blending_date
    validate :valid_warehouse_id
    validate :valid_blending_recipe_id
    
    def valid_warehouse_id
      return if warehouse_id.nil?
      
      wh = Warehouse.find_by_id warehouse_id
      
      if wh.nil? 
        self.errors.add(:warehouse_id, "Harus ada Warehouse Id")
        return self 
      end
    end
    
    def valid_blending_recipe_id
      return if blending_recipe_id.nil?
      
      br = BlendingRecipe.find_by_id blending_recipe_id
      
      if br.nil? 
        self.errors.add(:blending_recipe_id, "Harus ada BlendingRecipe Id")
        return self 
      end
    end
    
    def self.active_objects
      return self
    end
    
    def self.create_object(params)
      new_object = self.new
      new_object.blending_recipe_id = params[:blending_recipe_id]
      new_object.warehouse_id = params[:warehouse_id]
      new_object.description = params[:description]
      new_object.blending_date = params[:blending_date]
      new_object.code = params[:code]
      if new_object.save
      end
      return new_object
    end
    
    def update_object(params)
      if self.is_confirmed?
        self.errors.add(:generic_errors, "Sudah di konfirmasi")
        return self 
      end
      self.blending_recipe_id = params[:blending_recipe_id]
      self.warehouse_id = params[:warehouse_id]
      self.description = params[:description]
      self.blending_date = params[:blending_date]
      self.code = params[:code]
      if self.save
      end
      return self
    end
    
    def delete_object
      self.destroy
      return self
    end
    
    def confirm_object(params)
      if self.is_confirmed?
        self.errors.add(:generic_errors, "Sudah di konfirmasi")
        return self 
      end
      
      # check source amount
      self.blending_recipe.blending_recipe_details.each do |brd|
         item_in_warehouse = WarehouseItem.find_or_create_object(
          :warehouse_id => self.warehouse_id,
          :item_id => brd.item_id)      
        if brd.amount > item_in_warehouse.amount
          self.errors.add(:generic_errors, "Stock quantity untuk Source items #{brd.item.name} tidak cukup")
          return self 
        end        
      end
      
      self.is_confirmed = true
      self.confirmed_at = params[:confirmed_at]
      if self.save
        self.update_blending_work_order_confirm
      end
      return self
    end
    
    def unconfirm_object
      if not self.is_confirmed?
        self.errors.add(:generic_errors, "belum di konfirmasi")
        return self 
      end
      item_in_warehouse = WarehouseItem.find_or_create_object(
          :warehouse_id => self.warehouse_id,
          :item_id => self.blending_recipe.target_item_id)      
      if self.blending_recipe.target_amount > item_in_warehouse.amount
        self.errors.add(:generic_errors, "Stock quantity untuk Target item tidak cukup")
        return self 
      end      
      self.is_confirmed = false
      self.confirmed_at = nil
      if self.save
        self.update_blending_work_order_unconfirm
      end
      return self
    end
    
    def update_blending_work_order_confirm
      total_cost = 0
      # deduce source item amount
      self.blending_recipe.blending_recipe_details.each do |brd|
        total_cost += (brd.amount * brd.item.avg_price).round(2)
        item_in_warehouse = WarehouseItem.find_or_create_object(
          :warehouse_id => self.warehouse_id,
          :item_id => brd.item_id)      
        new_stock_mutation = StockMutation.create_object(
          :source_class => self.class.to_s, 
          :source_id => self.id ,  
          :amount => brd.amount ,  
          :status => ADJUSTMENT_STATUS[:deduction],  
          :mutation_date => self.blending_date ,  
          :warehouse_id => self.warehouse_id ,
          :warehouse_item_id => item_in_warehouse.id,
          :item_id => brd.item_id,
          :item_case => ITEM_CASE[:ready],
          :source_code => self.code
          ) 
        new_stock_mutation.stock_mutate_object
      end
      
      # update avg_price target_item
      item_price = (total_cost / self.blending_recipe.target_amount).round(2)
      self.blending_recipe.target_item.calculate_avg_price(
        :added_amount => self.blending_recipe.target_amount,
        :added_avg_price => item_price)
        
      # add target_item
      item_in_warehouse = WarehouseItem.find_or_create_object(
          :warehouse_id => self.warehouse_id,
          :item_id => self.blending_recipe.target_item_id)      
        new_stock_mutation = StockMutation.create_object(
          :source_class => self.class.to_s, 
          :source_id => self.id ,  
          :amount => self.blending_recipe.target_amount ,  
          :status => ADJUSTMENT_STATUS[:addition],  
          :mutation_date => self.blending_date ,  
          :warehouse_id => self.warehouse_id ,
          :warehouse_item_id => item_in_warehouse.id,
          :item_id => self.blending_recipe.target_item_id,
          :item_case => ITEM_CASE[:ready],
          :source_code => self.code
          ) 
        new_stock_mutation.stock_mutate_object
      
      # create journal
      AccountingService::CreateBlendingWorkOrderJournal.create_confirmation_journal(self,total_cost)
    end
    
    def update_blending_work_order_unconfirm
      self.blending_recipe.blending_recipe_details.each do |brd|
        stock_mutation = StockMutation.where(
            :source_class => self.class.to_s, 
            :source_id => self.id,
            :item_id => brd.item_id
            ).first
        stock_mutation.reverse_stock_mutate_object  
        stock_mutation.delete_object
      end
      target_stock_mutation =  StockMutation.where(
            :source_class => self.class.to_s, 
            :source_id => self.id,
            :item_id => self.blending_recipe.target_item_id
            ).first
      target_stock_mutation.reverse_stock_mutate_object  
      target_stock_mutation.delete_object
      AccountingService::CreateBlendingWorkOrderJournal.undo_create_confirmation_journal(self)
    end
    
end
