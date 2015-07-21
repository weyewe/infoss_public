class Api::SubTypesController < Api::BaseApiController
  
  def index
    
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
      @objects = SubType.joins(:item_type).where{  
        ( name =~ livesearch )  
      }.page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = SubType.joins(:item_type).where{ 
        ( name =~ livesearch  ) 
      }.count
      
      # calendar
      
    elsif params[:parent_id].present?
      # @group_loan = GroupLoan.find_by_id params[:parent_id]
      @objects = SubType.
                  where(:sub_type_id => params[:parent_id]).
                  page(params[:page]).per(params[:limit]).order("id DESC")
      @total = SubType.where(:sub_type_id => params[:parent_id]).count 
    else
      @objects = SubType.joins(:item_type).page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = SubType.joins(:item_type). count
    end
    
    
    
    
    
    # render :json => { :sub_types => @objects , :total => @total, :success => true }
  end

  def create
    @object = SubType.create_object( params[:sub_type] )  
    
    
 
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :sub_types => [@object] , 
                        :total => SubType.active_objects.count }  
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
    
    @object = SubType.find_by_id params[:id] 
    @object.update_object( params[:sub_type])
     
    if @object.errors.size == 0 
      @total = SubType.active_objects.count
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
    @object = SubType.find(params[:id])
    @object.delete_object

    if not @object.persisted? 
      render :json => { :success => true, :total => SubType.active_objects.count }  
    else
      render :json => { :success => false, :total => SubType.active_objects.count }  
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
      @objects = SubType.where{ 
                            ( name =~ query ) 
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = SubType.where{ 
              ( name =~ query )  
                              }.count
    else
      @objects = SubType.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = SubType.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
