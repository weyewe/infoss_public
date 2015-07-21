class Action < ActiveRecord::Base
    
    has_many :action_assignments
    
    def self.create_object( params ) 
        new_object = self.new 
        
        new_object.section_id  = params[:section_id]
        new_object.name = params[:name]
        new_object.action_name = params[:action_name] 
        new_object.save
        
        return new_object
        
    end
    
    def update_object( params )  
        self.section_id  = params[:section_id]
        self.name = params[:name]
        self.action_name = params[:action_name] 
        self.save
        
        return self 
    end
    
    def delete_object
        if self.action_assigments.count != 0 
            self.errors.add(:generic_errors, "Sorry dude.. there are actions")
            return self 
        end
        
        self.destroy 
    end
    
end
