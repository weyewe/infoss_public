class BatchSource < ActiveRecord::Base
    has_many :batch_source_allocations
    has_many :batch_instances, :through => :batch_source_allocation
    
    belongs_to :item
    
    def self.active_objects
        self
    end
    
    def active_children
        self.batch_source_allocations
    end
    
    def self.create_object( params ) 
      new_object = self.new 

      new_object.item_id            = params[:item_id       ]
      new_object.status             = params[:status      ]
      new_object.source_class       = params[:source_class    ]   
      new_object.source_id          = params[:source_id ] 
      new_object.generated_date     = params[:generated_date  ]      
      new_object.amount             = params[:amount ]
      
      if new_object.save
          new_object.unallocated_amount =  new_object.amount
          new_object.save 
      end
      
      return new_object
    end
    
    def update_unallocated_amount(  new_amount  )
        self.unallocated_amount =  self.unallocated_amount + new_amount 
        self.save 
    end
    
    def delete_object 
        self.destroy 
    end
    
  
end
