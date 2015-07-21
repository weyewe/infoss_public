class Api::RollerBuildersController < Api::BaseApiController
  
  def index
     
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
        
        
        @objects = RollerBuilder.joins(:roller_type,:machine,
        :uom,:core_builder).where{
          (
            ( name =~  livesearch )  | 
            ( roller_type.name =~ livesearch ) | 
            ( sku_roller_new_core =~ livesearch ) | 
            ( sku_roller_used_core =~ livesearch ) | 
            ( uom.name =~ livesearch ) | 
            ( machine.name =~ livesearch ) | 
            ( core_builder.base_sku =~ livesearch ) | 
            ( core_builder.name =~ livesearch ) 
          )

        }.page(params[:page]).per(params[:limit]).order("id DESC")

        @total = RollerBuilder.joins(:roller_type,:machine,:compound,:adhesive,
        :uom,:core_builder).where{
          (
            ( name =~  livesearch )  | 
            ( roller_type.name =~ livesearch ) | 
            ( sku_roller_new_core =~ livesearch ) | 
            ( sku_roller_used_core =~ livesearch ) | 
            ( uom.name =~ livesearch ) | 
            ( machine.name =~ livesearch ) | 
            ( core_builder.base_sku =~ livesearch ) | 
            ( core_builder.name =~ livesearch ) 
          )
        }.count
   
    else
      puts "In this shite"
      @objects = RollerBuilder.page(params[:page]).per(params[:limit]).order("id DESC")
      @total = RollerBuilder.count 
    end
    
    
    # render :json => { :roller_builders => @objects , :total => @total , :success => true }
  end

  def create
    @object = RollerBuilder.create_object( params[:roller_builder] )
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :roller_builders => [@object] , 
                        :total => RollerBuilder.active_objects.count  }  
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
    @object = RollerBuilder.find(params[:id]) 
    

    @object.update_object( params[:roller_builder] )
    
     
    if @object.errors.size == 0 
      @total = RollerBuilder.active_objects.count
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
    @object = RollerBuilder.find_by_id params[:id]
    @total = RollerBuilder.count
  end

  def destroy
    @object = RollerBuilder.find(params[:id])
    
    begin
      ActiveRecord::Base.transaction do 
        @object.delete_object 
      end
    rescue ActiveRecord::ActiveRecordError  
    else
    end
    
    

    if not @object.persisted?  
      render :json => { :success => true, :total => RollerBuilder.active_objects.count }  
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
      @objects = RollerBuilder.joins(:roller_type,:machine,
        :uom,:core_builder).where{ 
          ( name =~  query )  | 
          ( roller_type.name =~ query ) | 
          ( sku_roller_new_core =~ query ) | 
          ( sku_roller_used_core =~ query ) | 
          ( uom.name =~ query ) | 
          ( machine.name =~ query ) | 
          ( core_builder.base_sku =~ query ) | 
          ( core_builder.name =~ query ) 
                            }.
                      page(params[:page]).
                      per(params[:limit]).
                      order("id DESC")
                        
      @total = RollerBuilder.joins(:roller_type,:machine,
        :uom,:core_builder).where{ 
            ( name =~  query )  | 
            ( roller_type.name =~ query ) | 
            ( sku_roller_new_core =~ query ) | 
            ( sku_roller_used_core =~ query ) | 
            ( uom.name =~ query ) | 
            ( machine.name =~ query ) | 
            ( core_builder.base_sku =~ query ) | 
            ( core_builder.name =~ query )  
        
                              }.count
    else
      @objects = RollerBuilder.joins(:roller_type,:machine,
        :uom,:core_builder).where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = RollerBuilder.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
