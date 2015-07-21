class Api::BlanketWarehouseMutationDetailsController < Api::BaseApiController
  
  def index
    @parent = BlanketWarehouseMutation.find_by_id params[:blanket_warehouse_mutation_id]
    @objects = @parent.active_children.joins(:blanket_warehouse_mutation, :item => [:uom]).page(params[:page]).per(params[:limit]).order("id DESC")
    @total = @parent.active_children.count
  end

  def create
   
    @parent = BlanketWarehouseMutation.find_by_id params[:blanket_warehouse_mutation_id]
    
  
    @object = BlanketWarehouseMutationDetail.create_object(params[:blanket_warehouse_mutation_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :blanket_warehouse_mutation_details => [@object] , 
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
    @object = BlanketWarehouseMutationDetail.find_by_id params[:id] 
    @parent = @object.blanket_warehouse_mutation 
    
    
    params[:blanket_warehouse_mutation_detail][:blanket_warehouse_mutation_id] = @parent.id  
    
    @object.update_object( params[:blanket_warehouse_mutation_detail])
     
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
    @object = BlanketWarehouseMutationDetail.find(params[:id])
    @parent = @object.blanket_warehouse_mutation 
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
      @objects = BlanketWarehouseMutationDetail.joins(:blanket_warehouse_mutation, :item => [:uom]).where{ 
        ( item.sku  =~ query ) | 
        ( item.name =~ query ) | 
        ( item.description  =~ query  )  | 
        ( code  =~ query  )  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = BlanketWarehouseMutationDetail.joins(:blanket_warehouse_mutation, :item => [:uom]).where{ 
        ( item.sku  =~ query ) | 
        ( item.name =~ query ) | 
        ( item.description  =~ query  )  |
        ( code  =~ query  )  
      }.count
    else
      @objects = BlanketWarehouseMutationDetail.where{ 
              (id.eq selected_id)  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
   
      @total = BlanketWarehouseMutationDetail.where{ 
              (id.eq selected_id)   
      }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
 
  
 
end
