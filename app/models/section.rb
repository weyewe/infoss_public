class Section < ActiveRecord::Base
    validates_uniqueness_of :name 
    has_many :actions
    
    def self.create_object( params ) 
        new_object = self.new 
        
        new_object.name = params[:name]
        new_object.controller_name = params[:controller_name]
        new_object.description = params[:description]
        new_object.save
        
        return new_object
        
    end
    
    def update_object( params )  
        self.name = params[:name]
        self.controller_name = params[:controller_name]
        self.description = params[:description]
        self.save
        
        return self 
    end
    
    def delete_object
        if self.actions.count != 0 
            self.errors.add(:generic_errors, "Sorry dude.. there are actions")
            return self 
        end
        
        self.destroy 
    end
    
    def self.create_master_detail_template( master_controller_name, master_name, detail_controller_name,  detail_name)
        
        master  = self.create_object(
                :name => master_name, 
                :controller_name => master_controller_name 
            )
    
        detail = self.create_object(
                :name => detail_name,
                :controller_name => detail_controller_name 
            )
            
            
        
        ["index", "create", "show", "update", "confirm", "unconfirm", "destroy", "search" ].each do |x|
            Action.create_object(
                    :section_id => master.id ,
                    :action_name => x ,
                    :name => x.capitalize
                )
        end
        
        ["index", "create", "show", "update",   "destroy", "search" ].each do |x|
                Action.create_object(
                    :section_id => detail.id ,
                    :action_name => x ,
                    :name => x.capitalize
                )
        end
        
        
    end
    
    def self.create_master_template( master_controller_name, master_name )
        
        master  = self.create_object(
                :name => master_name, 
                :controller_name => master_controller_name 
            )
    
   
            
            
        
        ["index", "create", "show", "update", "confirm", "unconfirm", "destroy", "search" ].each do |x|
            Action.create_object(
                    :section_id => master.id ,
                    :action_name => x ,
                    :name => x.capitalize
                )
        end
        
 
        
    end
    
    
    
=begin
        base_path = Rails.root.to_s + "/" + "app/views/" 
        view_api_folder =  base_path + "api/*"
        Dir[ view_api_folder ]
        
=end 
    def self.create_base_section_actions
        base_path = Rails.root.to_s + "/" + "app/controllers/" 
        controller_api_folder =  base_path + "api/*"
        
        array = [] 
        Dir[ controller_api_folder ].each do |file_name|
            file_name = file_name.gsub('_controller.rb', '')
            file_name  = file_name.gsub(base_path, '')
          array << file_name
        end
        
        # "/home/ubuntu/workspace/app/controllers/api/roles_controller.rb"
        array = array.sort 
        array.each do |filename|
            next if Section.find_by_controller_name filename 
            
            public_name = filename.gsub('api/', '')
            public_name = public_name.split('_')
            result_name = "" 
            public_name.each do |part|
                result_name << part.capitalize
            end
            
            self.create_master_template( filename, result_name )
        end
        
        # MENU_ACTION_CONSTANT.each do |key, value | 
        #     position = value[:position]
        #     group_name = value[:text]
        #     tab = value[:group]
            
        #     value[:nodes].each do |x| 
        #         result_name = x[2]
        #         is_only_master = x[1]
        #         controller_name = x[0]
        #         next if Section.find_by_controller_name controller_name 
                
        #         self.create_master_template( 
        #                 :position => position,
        #                 :group_name => group_name,
        #                 :tab => tab, 
        #                 :controller_name => controller_name , 
        #                 :result_name => result_name 
        #             )
        #         if not is_only_master 
                    
        #         end
        
                
        #     end
        # end
        

    end
    
end
