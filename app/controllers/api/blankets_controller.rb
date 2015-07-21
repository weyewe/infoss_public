class Api::BlanketsController < Api::BaseApiController
  
  def index
     
    
    query_code = Blanket.joins(:machine,:contact)
    
    
    if params[:livesearch].present?  
      livesearch = "%#{params[:livesearch]}%"
        
        
      query_code = query_code.where{
          (
            ( contact.name =~ livesearch ) |
            ( machine.name =~ livesearch ) | 
            ( name =~ livesearch ) | 
            ( sku =~ livesearch )
          )

        }  .page(params[:page]).per(params[:limit])
 
    end
    
    @objects =  query_code.page(params[:page]).per(params[:limit])
    @total = query_code.count 
    
    # render :json => { :blankets => @objects , :total => @total , :success => true }
  end

  def create
    @object = Blanket.create_object( params[:blanket] )
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :blankets => [@object] , 
                        :total => Blanket.active_objects.count  }  
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
    @object = Blanket.find(params[:id]) 
    

    @object.update_object( params[:blanket] )
    
     
    if @object.errors.size == 0 
      @total = Blanket.active_objects.count
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
    @object = Blanket.find_by_id params[:id]
    @total = Blanket.count
  end

  def destroy
    @object = Blanket.find(params[:id])
    
    begin
      ActiveRecord::Base.transaction do 
        @object.delete_object 
      end
    rescue ActiveRecord::ActiveRecordError  
    else
    end
    
    

    if not @object.persisted?  
      render :json => { :success => true, :total => Blanket.active_objects.count }  
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
      @objects = Blanket.joins(:machine,:contact).where{ 
            ( contact.name =~ query ) |
            ( machine.name =~ query ) 
                              }.
                        page(params[:page]).
                        per(params[:limit])
                        # order("id DESC")
                        
      @total = Blanket.joins(:machine,:contact).where{ 
            ( contact.name =~ query ) |
            ( machine.name =~ query ) 
        
                              }.count
    else
      @objects = Blanket.joins(:machine,:contact).where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit])
                        # order("id DESC")
   
      @total = Blanket.joins(:machine,:contact).where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
