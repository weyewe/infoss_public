class RollBlanketUsage < ActiveRecord::Base
    
    validates_presence_of :blanket_order_detail_id
    validates_presence_of :batch_instance_id
    validates_presence_of :defect_amount
    validates_presence_of :finish_amount
    validates_presence_of :reject_amount
    
    belongs_to :batch_instance
    belongs_to :blanket_order_detail
    
    validate :total_amount_not_zero
    validate :valid_batch_instance_id
    
    validate :valid_blanket_order_detail_id
    validate :batch_instance_must_come_from_the_item_specified_in_blanket 
    
    
    
    def valid_batch_instance_id
        return if not batch_instance_id.present? 
        
        object = BatchInstance.find_by_id batch_instance_id
        
        if object.nil?
            self.errors.add(:batch_instance_id, "Harus memilih batch")
            return self 
        end
         
    end
    
    def valid_blanket_order_detail_id
        return if not blanket_order_detail_id.present? 
        
        object = BlanketOrderDetail.find_by_id blanket_order_detail_id
        
        if object.nil?
            self.errors.add(:blanket_order_detail_id, "Harus memilih blanket order detail")
            return self 
        end
        
        if not object.is_finished?
            self.errors.add(:blanket_order_detail_id, "Harus finished")
            return self 
        end
         
    end
    
     def batch_instance_must_come_from_the_item_specified_in_blanket
         return if self.errors.size != 0 
         batch_instance_object = BatchInstance.find_by_id batch_instance_id 
         blanket_order_detail_object= BlanketOrderDetail.find_by_id blanket_order_detail_id
         
         if not blanket_order_detail_object.blanket.roll_blanket_item_id == batch_instance_object.item_id 
             self.errors.add(:batch_instance_id, "Harus sesuai dengan roll blanket yang diatur di blanket")
             return self 
         end
         
     end
    
    def total_amount_not_zero
        return if not finish_amount.present? or 
            not defect_amount.present? or 
            not reject_amount.present? 
        
        if finish_amount < BigDecimal("0")
            self.errors.add(:finish_amount, "Tidak boleh negative")
            return self 
        end
        
        if defect_amount < BigDecimal("0")
            self.errors.add(:defect_amount, "Tidak boleh negative")
            return self 
        end
        
        if reject_amount < BigDecimal("0")
            self.errors.add(:reject_amount, "Tidak boleh negative")
            return self 
        end
        
        if finish_amount + defect_amount  + reject_amount <= BigDecimal("0")
            self.errors.add(:generic_errors, "Jumlah defect, finish dan reject harus lebih besar dari 0")
            return self 
        end
    end
    
    def total_used
        defect_amount + finish_amount + reject_amount
    end
    
    def self.create_object(params)
        new_object = self.new 
        new_object.blanket_order_detail_id = params[:blanket_order_detail_id]
        new_object.batch_instance_id = params[:batch_instance_id]
        
        new_object.defect_amount = BigDecimal( params[:defect_amount]) 
        new_object.reject_amount = BigDecimal( params[:reject_amount]) 
        new_object.finish_amount = BigDecimal( params[:finish_amount])
        
        if new_object.save
            # update batch_insance
            new_object.batch_instance.update_amount(  -1*new_object.total_used  )
            
            # create batch stock mutation for defect
            new_object.create_reject_batch_stock_mutation if new_object.reject_amount > BigDecimal("0")
            new_object.create_defect_batch_stock_mutation if new_object.defect_amount > BigDecimal("0")
            new_object.create_finish_batch_stock_mutation if new_object.finish_amount > BigDecimal("0")
            
            
        end
        
        return new_object
    end
    
    def create_reject_batch_stock_mutation
        BatchStockMutation.create_object(
              :source_class => self.class.to_s, 
              :source_id => self.id ,  
              :amount => self.reject_amount ,  
              :status => ADJUSTMENT_STATUS[:deduction],  
              :mutation_date => self.blanket_order_detail.finished_at     ,  
              :item_id =>  self.blanket_order_detail.blanket.item.id   ,
              :batch_instance_id => self.batch_instance_id,
              :description => "[REJECT] blanket manufacturing"
              )  
    end
    
    def create_defect_batch_stock_mutation
        BatchStockMutation.create_object(
              :source_class => self.class.to_s, 
              :source_id => self.id ,  
              :amount => self.defect_amount ,  
              :status => ADJUSTMENT_STATUS[:deduction],  
              :mutation_date => self.blanket_order_detail.finished_at     ,  
              :item_id =>  self.blanket_order_detail.blanket.item.id   ,
              :batch_instance_id => self.batch_instance_id,
              :description => "[DEFECT] blanket manufacturing"
              )  
    end
    
    def create_finish_batch_stock_mutation
        BatchStockMutation.create_object(
              :source_class => self.class.to_s, 
              :source_id => self.id ,  
              :amount => self.finish_amount ,  
              :status => ADJUSTMENT_STATUS[:deduction],  
              :mutation_date => self.blanket_order_detail.finished_at     ,  
              :item_id =>  self.blanket_order_detail.blanket.item.id   ,
              :batch_instance_id => self.batch_instance_id,
              :description => "[FINISH] blanket manufacturing"
              )  
    end
    
    def delete_object
         self.batch_instance.update_amount(   self.total_used  )
         
         BatchStockMutation.where(
              :source_class => self.class.to_s, 
              :source_id => self.id  
              )  .each {|x| x.destroy } 
        
        self.destroy 
    end
end
