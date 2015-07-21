class BatchSourceAllocation < ActiveRecord::Base
    belongs_to :batch_source 
    belongs_to :batch_instance 
    
    validates_presence_of :batch_source_id
    validates_presence_of :batch_instance_id
    
    validate :valid_final_batch_instance_amount 
    
    validate :valid_final_batch_source_amount
    
    validate :valid_batch_source_id
    validate :valid_batch_instance_id
    
    
    def valid_batch_source_id
      return if not batch_source_id.present?
      object = BatchSource.find_by_id batch_source_id
      
      if object.nil?
        self.errors.add(:generic_errors, "Harus ada Batch Source")
        return self 
      end
      
    end
    
    def valid_batch_instance_id
      return if not batch_instance_id.present?
      object = BatchInstance.find_by_id batch_instance_id
      
      if object.nil?
        self.errors.add(:batch_instance_id, "Harus ada Batch Instance")
        return self 
      end
      
    end
  
    def valid_final_batch_instance_amount
      if status == ADJUSTMENT_STATUS[:deduction]
        if batch_instance.amount  - self.amount < BigDecimal("0")
          self.errors.add(:generic_errors, "Gagal. Jumlah akhir di batch #{batch_instance.name} menjadi negative")
          return self 
        end
      end
    end
    
    def valid_final_batch_source_amount
      return if amount == BigDecimal("0")
      return if batch_source.nil? 
      
      if batch_source.amount - amount < BigDecimal("0")
        self.errors.add(:amount, "Hasil akhir di batch Source tidak boleh negative")
        return self 
      end
    end
    
    def self.create_object( params )
      new_object = self.new      
      new_object.batch_source_id     = params[:batch_source_id  ]       
      new_object.batch_instance_id   = params[:batch_instance_id]      
      new_object.amount              = params[:amount ] 
      
      if new_object.save
        new_object.status = new_object.batch_source.status 
        new_object.save  
        
        # create batch stock mutation
        new_batch_stock_mutation = BatchStockMutation.create_object(
          :source_class => new_object.class.to_s, 
          :source_id => new_object.id ,  
          :amount => new_object.amount ,  
          :status => new_object.status ,  
          :mutation_date => new_object.batch_source.generated_date   ,  
          :item_id =>  new_object.batch_source.item_id  ,
          :batch_instance_id => new_object.batch_instance_id,
          :description => "Base Allocation"
          )  
 
        multiplier = 1 
        multiplier = -1 if new_object.status == ADJUSTMENT_STATUS[:deduction]
        
        new_object.batch_instance.update_amount(
            multiplier * new_object.amount 
           )
        new_object.batch_instance.update_total_allocated_amount( multiplier * new_object.amount  )
           
        new_object.batch_source.update_unallocated_amount(   -1*new_object.amount )
        
        
          
          
      end
      
      return new_object 
    end
  
    
    
    def delete_object
      if self.status == ADJUSTMENT_STATUS[:addition]
        if batch_instance.amount - self.amount <  BigDecimal("0")
          self.errors.add(:generic_errors, "Gagal. Jumlah akhir di batch #{batch_instance.name} menjadi negative")
          return self 
        end
      end
      
      BatchStockMutation.where(
          :source_class => self.class.to_s, 
          :source_id => self.id  ,
          :batch_instance_id => self.batch_instance_id
          ) .each do |x|
      
        x.delete_object 
      end
      
      multiplier = 1 
      multiplier = -1 if self.status == ADJUSTMENT_STATUS[:addition]
      
      batch_instance.update_amount( multiplier * self.amount )
      batch_instance.update_total_allocated_amount( multiplier * self.amount  )
      
      batch_source.update_unallocated_amount(   amount )
      
      
      
      self.destroy 
    end
end
