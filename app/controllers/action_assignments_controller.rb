class ActionAssignmentsController < ApplicationController
    layout 'action_assignment'
    
    def index
            
        
        @user = User.find_by_authentication_token params[:auth_token]
        if @user.nil?
          redirect_to root_url 
          return
        end
        
        @sections = Section.includes(:actions).order("sections.id ASC").all 
    end
    
    
end
