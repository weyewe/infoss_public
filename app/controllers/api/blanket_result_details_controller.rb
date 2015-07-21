class Api::BlanketResultDetailsController < Api::BaseApiController
  
  def index
    params[:blanket_detail_id] = params[:blanket_result_id]
    
    @parent = BlanketOrderDetail.find_by_id params[:blanket_result_id]
   
    
    query = @parent.roll_blanket_usages.joins(:batch_instance)
    
    @objects = query.page(params[:page]).per(params[:limit]).order("id DESC")
    @total = query.count
    
  end

  def create
  
    @parent = BlanketOrderDetail.find_by_id params[:blanket_result_id]
 
    
    
  
    @object = RollBlanketUsage.create_object(params[:blanket_result_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :blanket_result_details => [@object] , 
                        :total => @parent.active_children.count }  
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
    @object = RollBlanketUsage.find(params[:id])  
    @parent = @object.blanket_order_detail
    @object.delete_object 
    
    if  not @object.persisted? 
      render :json => { :success => true, :total => @parent.active_children.count }  
    else
      render :json => { :success => false, :total =>@parent.active_children.count ,
            :message => {
              :errors => extjs_error_format( @object.errors )  
            }
      }  
    end
  end
   
 
  
 
end
