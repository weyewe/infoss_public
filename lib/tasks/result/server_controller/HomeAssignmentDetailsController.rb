class Api::HomeAssignmentDetailsController < Api::BaseApiController
  
  def index
    @parent = HomeAssignment.find_by_id params[:home_assignment_id]
    @objects = @parent.active_home_assignment_details.joins(:home_assignment, :account).page(params[:page]).per(params[:limit]).order("id DESC")
    @total = @parent.active_home_assignment_details.count
  end

  def create
   
    @parent = HomeAssignment.find_by_id params[:home_assignment_id]
    
  
    @object = HomeAssignmentDetail.create_object(params[:home_assignment_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :home_assignment_details => [@object] , 
                        :total => @parent.active_home_assignment_details.count }  
    else
      msg = {
        :success => false, 
        :message => {
          :errors => extjs_error_format( @object.errors )  
        }
      }
      
      render :json => msg
      return                          
    end
  end

  def update
    @object = HomeAssignmentDetail.find_by_id params[:id] 
    @parent = @object.home_assignment 
    
    
    params[:home_assignment_detail][:home_assignment_id] = @parent.id  
    
    @object.update_object( params[:home_assignment_detail])
     
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :home_assignment_details => [@object],
                        :total => @parent.active_home_assignment_details.count  } 
    else
      msg = {
        :success => false, 
        :message => {
          :errors => extjs_error_format( @object.errors )  
        }
      }
      
      render :json => msg
      return  
    end
  end

  def destroy
    @object = HomeAssignmentDetail.find(params[:id])
    @parent = @object.home_assignment 
    @object.delete_object 

    if  not @object.persisted? 
      render :json => { :success => true, :total => @parent.active_home_assignment_details.count }  
    else
      render :json => { :success => false, :total =>@parent.active_home_assignment_details.count ,
            :message => {
              :errors => extjs_error_format( @object.errors )  
            }
            }  
    end
  end
 
  
 
end
