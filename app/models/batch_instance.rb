class BatchInstance < ActiveRecord::Base
    
    validates_presence_of :item_id 
    validates_presence_of :name 
    validates_uniqueness_of :name
    
    has_many :batch_source_allocations 
    has_many :batch_sources, :through => :batch_source_allocation
    belongs_to :item 
    
    
    validate :item_type_must_be_batch
    
    def item_type_must_be_batch
        return if not item_id.present?
        
        object = Item.find_by_id item_id
        
        if object.nil?
            self.errors.add(:item_id, "Harus ada Item")
            return self 
        end
        
        if not object.is_batched?
            self.errors.add(:item_id, "Item harus memiliki tipe Batched")
            return self 
        end
    end
      
    def self.create_object( params ) 
        new_object = self.new
        
        new_object.item_id         = params[:item_id]
        new_object.name            = params[:name]
        new_object.description     = params[:description]    
        new_object.manufactured_at = params[:manufactured_at]
        
        
        new_object.save 
        return new_object 
        
    end
    
    def self.active_objects
        self
    end
    
    def item_type 
        self.item.item_type 
    end
    
    def update_object( params ) 
        self.item_id = params[:item_id]
        self.name            = params[:name]
        self.description     = params[:description]    
        self.manufactured_at = params[:manufactured_at]
        self.save 
        
        return self 
    end
    
    
    def update_amount( new_amount )
        self.amount = self.amount + new_amount
        self.save 
    end
    
    def update_total_allocated_amount( new_amount ) 
        self.total_allocated_amount = self.total_allocated_amount + new_amount
        self.save 
    end
    
    def delete_object
        if self.batch_source_allocations.count != 0 
            self.errors.add(:generic_errors, "Sudah ada batch source allocation")
            return self 
        end
        
        self.destroy 
    end
end
