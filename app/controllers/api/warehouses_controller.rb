class Api::WarehousesController < Api::BaseApiController
  
  def index
    
    
    

    
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
      @objects = Warehouse.where{  
        
        ( code =~ livesearch ) | 
        ( name =~ livesearch ) | 
        ( description  =~ livesearch  )  
        
      }.page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = Warehouse.where{ 
        ( code =~ livesearch ) | 
        ( name =~ livesearch ) | 
        ( description  =~ livesearch  )   
      }.count
      
      # calendar
      
    elsif params[:parent_id].present?
      # @group_loan = GroupLoan.find_by_id params[:parent_id]
      @objects = Warehouse.
                  where(:warehouse_id => params[:parent_id]).
                  page(params[:page]).per(params[:limit]).order("id DESC")
      @total = Warehouse.where(:warehouse_id => params[:parent_id]).count 
    else
      @objects = Warehouse.page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = Warehouse.count
    end
    
    
    
    
    
    # render :json => { :warehouses => @objects , :total => @total, :success => true }
  end

  def create
    @object = Warehouse.create_object( params[:warehouse] )  
    
    
 
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :warehouses => [@object] , 
                        :total => Warehouse.active_objects.count }  
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
    
    @object = Warehouse.find_by_id params[:id] 
    @object.update_object( params[:warehouse])
     
    if @object.errors.size == 0 
      @total = Warehouse.active_objects.count
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
    @object = Warehouse.find(params[:id])
    @object.delete_object

    if not @object.persisted? 
      render :json => { :success => true, :total => Warehouse.active_objects.count }  
    else
      render :json => { :success => false, :total => Warehouse.active_objects.count }  
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
      @objects = Warehouse.where{ 
            ( code  =~ query ) | 
        ( name =~ query ) | 
        ( description  =~ query  )  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = Warehouse.where{ 
               ( code  =~ query ) | 
        ( name =~ query ) | 
        ( description  =~ query  )  
                              }.count
    else
      @objects = Warehouse.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = Warehouse.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
