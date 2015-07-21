class Api::RecoveryOrderDetailsController < Api::BaseApiController
  
  def index
    @parent = RecoveryOrder.find_by_id params[:recovery_order_id]
    @objects = @parent.active_children.joins(:recovery_order, :roller_identification_form_detail,:roller_builder).page(params[:page]).per(params[:limit]).order("id DESC")
    @total = @parent.active_children.count
  end

  def create
   
    @parent = RecoveryOrder.find_by_id params[:recovery_order_id]
    
  
    @object = RecoveryOrderDetail.create_object(params[:recovery_order_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :recovery_order_details => [@object] , 
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

  def update
    @object = RecoveryOrderDetail.find_by_id params[:id] 
    @parent = @object.recovery_order 
    
    
    params[:recovery_order_detail][:recovery_order_id] = @parent.id  
    
    @object.update_object( params[:recovery_order_detail])
     
    if @object.errors.size == 0 
      @total = @parent.active_children.count
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
    @object = RecoveryOrderDetail.find(params[:id])
    @parent = @object.recovery_order 
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
  
  def search
    search_params = params[:query]
    selected_id = params[:selected_id]
    if params[:selected_id].nil?  or params[:selected_id].length == 0 
      selected_id = nil
    end
    
    query = "%#{search_params}%"
    # on PostGre SQL, it is ignoring lower case or upper case 
    
    if  selected_id.nil?
      @objects = RecoveryOrderDetail.joins(:recovery_order, :roller_identification_form_detail,:roller_builder).where{ 
        ( roller_builder.base_sku  =~ query ) 
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = RecoveryOrderDetail.joins(:recovery_order, :roller_identification_form_detail,:roller_builder).where{ 
        ( roller_builder.base_sku  =~ query ) 
      }.count
    else
      @objects = RecoveryOrderDetail.where{ 
              (id.eq selected_id)  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
   
      @total = RecoveryOrderDetail.where{ 
              (id.eq selected_id)   
      }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
 
  
 
end
