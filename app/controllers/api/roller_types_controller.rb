class Api::RollerTypesController < Api::BaseApiController
  
  def index
     
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
        
        
        @objects = RollerType.where{
          (
            ( name =~  livesearch )  | 
            ( description =~ livesearch )
          )

        }.page(params[:page]).per(params[:limit]).order("id DESC")

        @total = RollerType.where{
          (
            ( name =~  livesearch )  | 
            ( description =~ livesearch ) 
          )
        }.count
   
    else
      puts "In this shite"
      @objects = RollerType.page(params[:page]).per(params[:limit]).order("id DESC")
      @total = RollerType.count 
    end
    
    
    # render :json => { :roller_types => @objects , :total => @total , :success => true }
  end

  def create
    @object = RollerType.create_object( params[:roller_type] )
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :roller_types => [@object] , 
                        :total => RollerType.active_objects.count  }  
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
    @object = RollerType.find(params[:id]) 
    

    @object.update_object( params[:roller_type] )
    
     
    if @object.errors.size == 0 
      @total = RollerType.active_objects.count
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
  
  def show
    @object = RollerType.find_by_id params[:id]
    @total = RollerType.count
  end

  def destroy
    @object = RollerType.find(params[:id])
    
    begin
      ActiveRecord::Base.transaction do 
        @object.delete_object 
      end
    rescue ActiveRecord::ActiveRecordError  
    else
    end
    
    

    if not @object.persisted?  
      render :json => { :success => true, :total => RollerType.active_objects.count }  
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
  
  
  def search
    search_params = params[:query]
    selected_id = params[:selected_id]
    if params[:selected_id].nil?  or params[:selected_id].length == 0 
      selected_id = nil
    end
    
    query = "%#{search_params}%"
    # on PostGre SQL, it is ignoring lower case or upper case 
    
    if  selected_id.nil?
      @objects = RollerType.where{ 
          ( name =~  query )  | 
          ( description =~ query ) 
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = RollerType.where{ 
          ( name =~  query )  | 
          ( description =~ query ) 
        
                              }.count
    else
      @objects = RollerType.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = RollerType.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
