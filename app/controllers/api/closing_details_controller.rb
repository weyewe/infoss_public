class Api::ClosingDetailsController < Api::BaseApiController
  
  def index
    @parent = Closing.find_by_id params[:closing_id]
    @objects = @parent.active_children.joins(:closing, :exchange).page(params[:page]).per(params[:limit]).order("id DESC")
    @total = @parent.active_children.count
  end

  def create
   
    @parent = Closing.find_by_id params[:closing_id]
    
  
    @object = ClosingDetail.create_object(params[:closing_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :closing_details => [@object] , 
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
    @object = ClosingDetail.find_by_id params[:id] 
    @parent = @object.closing 
    
    
    params[:closing_detail][:closing_id] = @parent.id  
    
    @object.update_object( params[:closing_detail])
     
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
    @object = ClosingDetail.find(params[:id])
    @parent = @object.closing 
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
      @objects = ClosingDetail.joins(:closing, :exchange).where{ 
        ( exchange.name  =~ query ) 
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = ClosingDetail.joins(:closing, :exchange ).where{ 
        ( exchange.name =~ query )  
      }.count
    else
      @objects = ClosingDetail.joins(:closing, :exchange ).where{ 
              (id.eq selected_id)  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
   
      @total = ClosingDetail.joins(:closing, :exchange ).where{ 
              (id.eq selected_id)   
      }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
 
  
 
end
