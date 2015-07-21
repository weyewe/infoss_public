class Api::RollerWarehouseMutationDetailsController < Api::BaseApiController
  
  def index
    @parent = RollerWarehouseMutation.find_by_id params[:roller_warehouse_mutation_id]
    @objects = @parent.active_children.joins(:roller_warehouse_mutation, :item => [:uom]).page(params[:page]).per(params[:limit]).order("id DESC")
    @total = @parent.active_children.count
  end

  def create
   
    @parent = RollerWarehouseMutation.find_by_id params[:roller_warehouse_mutation_id]
    
  
    @object = RollerWarehouseMutationDetail.create_object(params[:roller_warehouse_mutation_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :roller_warehouse_mutation_details => [@object] , 
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
    @object = RollerWarehouseMutationDetail.find_by_id params[:id] 
    @parent = @object.roller_warehouse_mutation 
    
    
    params[:roller_warehouse_mutation_detail][:roller_warehouse_mutation_id] = @parent.id  
    
    @object.update_object( params[:roller_warehouse_mutation_detail])
     
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
    @object = RollerWarehouseMutationDetail.find(params[:id])
    @parent = @object.roller_warehouse_mutation 
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
      @objects = RollerWarehouseMutationDetail.joins(:roller_warehouse_mutation, :item => [:uom]).where{ 
        ( item.sku  =~ query ) | 
        ( item.name =~ query ) | 
        ( item.description  =~ query  )  | 
        ( code  =~ query  )  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = RollerWarehouseMutationDetail.joins(:roller_warehouse_mutation, :item => [:uom]).where{ 
        ( item.sku  =~ query ) | 
        ( item.name =~ query ) | 
        ( item.description  =~ query  )  |
        ( code  =~ query  )  
      }.count
    else
      @objects = RollerWarehouseMutationDetail.where{ 
              (id.eq selected_id)  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
   
      @total = RollerWarehouseMutationDetail.where{ 
              (id.eq selected_id)   
      }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
 
  
 
end
