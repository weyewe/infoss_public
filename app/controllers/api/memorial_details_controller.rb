class Api::MemorialDetailsController < Api::BaseApiController
  
  def index
    @parent = Memorial.find_by_id params[:memorial_id]
    @objects = @parent.active_children.joins(:memorial, :account).page(params[:page]).per(params[:limit]).order("id DESC")
    @total = @parent.active_children.count
  end

  def create
   
    @parent = Memorial.find_by_id params[:memorial_id]
    
  
    @object = MemorialDetail.create_object(params[:memorial_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :memorial_details => [@object] , 
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
    @object = MemorialDetail.find_by_id params[:id] 
    @parent = @object.memorial 
    
    
    params[:memorial_detail][:memorial_id] = @parent.id  
    
    @object.update_object( params[:memorial_detail])
     
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
    @object = MemorialDetail.find(params[:id])
    @parent = @object.memorial 
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
      @objects = MemorialDetail.joins(:memorial, :account).where{ 
        ( code  =~ query ) | 
        ( account.code =~ query ) | 
        ( account.name  =~ query  )  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = MemorialDetail.joins(:memorial, :account).where{ 
        ( code  =~ query ) | 
        ( account.code =~ query ) | 
        ( account.name  =~ query  )  
      }.count
    else
      @objects = MemorialDetail.where{ 
              (id.eq selected_id)  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
   
      @total = MemorialDetail.where{ 
              (id.eq selected_id)   
      }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
 
  
 
end
