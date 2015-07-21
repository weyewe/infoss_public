class BatchStockMutation < ActiveRecord::Base
  belongs_to :batch_instance
    
    def self.create_object( params ) 
        new_object = self.new
        
        new_object.source_class     =   params[:source_class] 
        new_object.source_id        =   params[:source_id]
        new_object.amount           =   params[:amount]
        new_object.status           =   params[:status]  
        new_object.mutation_date    =   params[:mutation_date]      
        new_object.item_id          =   params[:item_id]    
        new_object.description      =   params[:description]     
        new_object.batch_instance_id = params[:batch_instance_id]
        new_object.save
        
        return new_object 
    end
    
    def delete_object
      self.destroy 
    end
end
