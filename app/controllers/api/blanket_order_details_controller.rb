class Api::BlanketOrderDetailsController < Api::BaseApiController
  
  def index
    @parent = BlanketOrder.find_by_id params[:blanket_order_id]
    @objects = @parent.active_children.joins(:blanket_order, :blanket).page(params[:page]).per(params[:limit]).order("id DESC")
    @total = @parent.active_children.count
  end

  def create
   
    @parent = BlanketOrder.find_by_id params[:blanket_order_id]
    
  
    @object = BlanketOrderDetail.create_object(params[:blanket_order_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :blanket_order_details => [@object] , 
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
    @object = BlanketOrderDetail.find_by_id params[:id] 
    @parent = @object.blanket_order 
    
    
    params[:blanket_order_detail][:blanket_order_id] = @parent.id  
    
    @object.update_object( params[:blanket_order_detail])
     
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
    @object = BlanketOrderDetail.find(params[:id])
    @parent = @object.blanket_order 
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
      @objects = BlanketOrderDetail.joins(:blanket_order, :blanket).where{ 
        ( blanket.roll_no  =~ query  )   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = BlanketOrderDetail.joins(:blanket_order, :blanket).where{ 
        ( blanket.roll_no  =~ query  )  
      }.count
    else
      @objects = BlanketOrderDetail.where{ 
              (id.eq selected_id)  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
   
      @total = BlanketOrderDetail.where{ 
              (id.eq selected_id)   
      }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
 
  
 
end
