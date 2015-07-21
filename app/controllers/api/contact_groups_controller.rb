class Api::ContactGroupsController < Api::BaseApiController
  
  def index
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
      @objects = ContactGroup.active_objects.where{ 

        (
          (name =~  livesearch )  | 
          ( description =~ livesearch )
        )
        
      }.page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = ContactGroup.active_objects.where{

        (
          (name =~  livesearch )  | 
          ( description =~ livesearch )
        )
        
      }.count
    else
      @objects = ContactGroup.active_objects.page(params[:page]).per(params[:limit]).order("id DESC")
      @total = ContactGroup.active_objects.count
    end
    
    
    
    # render :json => { :contact_groups => @objects , :total => @total, :success => true }
  end

  def create
    @object = ContactGroup.create_object( params[:contact_group] )  
    
    
 
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :contact_groups => [@object] , 
                        :total => ContactGroup.active_objects.count }  
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
    
    @object = ContactGroup.find_by_id params[:id] 
    @object.update_object( params[:contact_group])
     
    if @object.errors.size == 0 
      @total = ContactGroup.active_objects.count
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
    @object = ContactGroup.find(params[:id])
    @object.delete_object

    if @object.is_deleted
      render :json => { :success => true, :total => ContactGroup.active_objects.count }  
    else
      render :json => { :success => false, :total => ContactGroup.active_objects.count }  
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
      @objects = ContactGroup.active_objects.where{ 
                (name =~ query)   | 
                ( description =~ query )
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = ContactGroup.active_objects.where{ 
            (name =~ query)  | 
            ( description =~ query )
                              }.count
    else
      @objects = ContactGroup.active_objects.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = ContactGroup.active_objects.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
