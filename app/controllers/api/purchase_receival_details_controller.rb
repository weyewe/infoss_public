class Api::PurchaseReceivalDetailsController < Api::BaseApiController
  
  def index
    @parent = PurchaseReceival.find_by_id params[:purchase_receival_id]
    @objects = @parent.active_children.joins(:purchase_receival, :item => [:uom]).page(params[:page]).per(params[:limit]).order("id DESC")
    @total = @parent.active_children.count
  end

  def create
   
    @parent = PurchaseReceival.find_by_id params[:purchase_receival_id]
    
  
    @object = PurchaseReceivalDetail.create_object(params[:purchase_receival_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :purchase_receival_details => [@object] , 
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
    @object = PurchaseReceivalDetail.find_by_id params[:id] 
    @parent = @object.purchase_receival 
    
    
    params[:purchase_receival_detail][:purchase_receival_id] = @parent.id  
    
    @object.update_object( params[:purchase_receival_detail])
     
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
    @object = PurchaseReceivalDetail.find(params[:id])
    @parent = @object.purchase_receival 
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
      @objects = PurchaseReceivalDetail.joins(:purchase_receival, :item => [:uom]).where{ 
        ( item.sku  =~ query ) | 
        ( item.name =~ query ) | 
        ( item.description  =~ query  )  | 
        ( code  =~ query  )  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = PurchaseReceivalDetail.joins(:purchase_receival, :item => [:uom]).where{ 
        ( item.sku  =~ query ) | 
        ( item.name =~ query ) | 
        ( item.description  =~ query  )  |
        ( code  =~ query  )  
      }.count
    else
      @objects = PurchaseReceivalDetail.where{ 
              (id.eq selected_id)  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
   
      @total = PurchaseReceivalDetail.where{ 
              (id.eq selected_id)   
      }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
 
  
 
end
