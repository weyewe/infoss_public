class Api::RecoveryAccessoryDetailsController < Api::BaseApiController
  
  def index
    @parent = RecoveryOrderDetail.find_by_id params[:recovery_order_detail_id]
    @objects = @parent.active_children.joins(:recovery_order_detail, :item => [:uom]).page(params[:page]).per(params[:limit]).order("id DESC")
    @total = @parent.active_children.count
  end

  def create
   
    @parent = RecoveryOrderDetail.find_by_id params[:recovery_order_detail_id]
    
  
    @object = RecoveryAccessoryDetail.create_object(params[:recovery_accessory_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :recovery_accessory_detail => [@object] , 
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
    @object = RecoveryAccessoryDetail.find_by_id params[:id] 
    @parent = @object.recovery_order_detail 
    
    
    params[:recovery_accessory_detail][:recovery_order_detail_id] = @parent.id  
    
    @object.update_object( params[:recovery_accessory_detail])
     
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
    @object = RecoveryAccessoryDetail.find(params[:id])
    @parent = @object.recovery_order_detail 
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
      @objects = RecoveryAccessoryDetail.joins(:recovery_order_detail, :item).where{ 
        ( item.sku  =~ query ) | 
        ( item.name =~ query ) | 
        ( item.description  =~ query  )  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = RecoveryAccessoryDetail.joins(:recovery_order_detail, :item).where{ 
        ( item.sku  =~ query ) | 
        ( item.name =~ query ) | 
        ( item.description  =~ query  )  
      }.count
    else
      @objects = RecoveryAccessoryDetail.joins(:recovery_order_detail, :item).where{ 
              (id.eq selected_id)  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
   
      @total = RecoveryAccessoryDetail.joins(:recovery_order_detail, :item).where{ 
              (id.eq selected_id)   
      }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
 
  
 
end
