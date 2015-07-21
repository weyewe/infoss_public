class ActionAssignment < ActiveRecord::Base
    
    belongs_to  :user
    belongs_to :action 
    
    def self.create_object( params ) 
        new_object = self.new 
        
        new_object.user_id  = params[:user_id]
        new_object.action_id = params[:action_id]  
        new_object.save
        
        return new_object
        
    end
    
    def update_object( params )  
        self.user_id  = params[:user_id]
        self.action_id = params[:action_id] 
        self.save
        
        return self 
    end
    
    def delete_object 
        
        self.destroy 
    end
    
end
