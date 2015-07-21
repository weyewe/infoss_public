class Api::MachinesController < Api::BaseApiController
  
  def index
     
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
        
        
        @objects = Machine.where{
          (
            ( code =~  livesearch )  | 
            ( name =~ livesearch ) | 
            ( description =~ livesearch ) 
          )

        }.page(params[:page]).per(params[:limit]).order("id DESC")

        @total = Machine.where{
          (
            ( code =~  livesearch )  | 
            ( name =~ livesearch ) | 
            ( description =~ livesearch ) 
          )
        }.count
   
    else
      puts "In this shite"
      @objects = Machine.page(params[:page]).per(params[:limit]).order("id DESC")
      @total = Machine.count 
    end
    
    
    # render :json => { :machines => @objects , :total => @total , :success => true }
  end

  def create
    @object = Machine.create_object( params[:machine] )
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :machines => [@object] , 
                        :total => Machine.active_objects.count  }  
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
    @object = Machine.find(params[:id]) 
    

    @object.update_object( params[:machine] )
    
     
    if @object.errors.size == 0 
      @total = Machine.active_objects.count
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
    @object = Machine.find_by_id params[:id]
    @total = Machine.count
  end

  def destroy
    @object = Machine.find(params[:id])
    
    begin
      ActiveRecord::Base.transaction do 
        @object.delete_object 
      end
    rescue ActiveRecord::ActiveRecordError  
    else
    end
    
    

    if not @object.persisted?  
      render :json => { :success => true, :total => Machine.active_objects.count }  
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
      @objects = Machine.where{ 
          ( code =~  query )  | 
          ( name =~ query ) | 
          ( description =~ query ) 
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = Machine.where{ 
          ( code =~  query )  | 
          ( name =~ query ) | 
          ( description =~ query ) 
        
                              }.count
    else
      @objects = Machine.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = Machine.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
