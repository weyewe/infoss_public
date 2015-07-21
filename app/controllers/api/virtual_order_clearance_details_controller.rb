class Api::VirtualOrderClearanceDetailsController < Api::BaseApiController
  
  def index
    @parent = VirtualOrderClearance.find_by_id params[:virtual_order_clearance_id]
    @objects = @parent.active_children.joins(:virtual_order_clearance, :virtual_delivery_order_detail).page(params[:page]).per(params[:limit]).order("id DESC")
    @total = @parent.active_children.count
  end

  def create
   
    @parent = VirtualOrderClearance.find_by_id params[:virtual_order_clearance_id]
    
  
    @object = VirtualOrderClearanceDetail.create_object(params[:virtual_order_clearance_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :virtual_order_clearance_details => [@object] , 
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
    @object = VirtualOrderClearanceDetail.find_by_id params[:id] 
    @parent = @object.virtual_order_clearance 
    
    
    params[:virtual_order_clearance_detail][:virtual_order_clearance_id] = @parent.id  
    
    @object.update_object( params[:virtual_order_clearance_detail])
     
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
    @object = VirtualOrderClearanceDetail.find(params[:id])
    @parent = @object.virtual_order_clearance 
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
      @objects = VirtualOrderClearanceDetail.joins(:virtual_order_clearance, :virtual_delivery_order_detail).where{ 
        ( code  =~ query  )  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = VirtualOrderClearanceDetail.joins(:virtual_order_clearance, :virtual_delivery_order_detail).where{ 
        ( code  =~ query  )  
      }.count
    else
      @objects = VirtualOrderClearanceDetail.where{ 
              (id.eq selected_id)  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
   
      @total = VirtualOrderClearanceDetail.where{ 
              (id.eq selected_id)   
      }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
 
  
 
end
