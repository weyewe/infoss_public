class Api::CoreBuildersController < Api::BaseApiController
  
  def index
     
    
    if params[:query].present? 
      query = "%#{params[:query]}%"
        
        
        @objects = CoreBuilder.joins(:machine,:uom).where{
          (
            ( name =~  query )  | 
            ( base_sku =~ query ) | 
            ( description =~ query ) | 
            ( machine.name=~ query ) | 
            ( core_builder_type_case =~ query ) | 
            ( sku_used_core =~ query ) | 
            ( sku_new_core =~ query ) | 
            ( uom.name =~ query )
          )

        }.page(params[:page]).per(params[:limit]).order("id DESC")

        @total = CoreBuilder.joins(:machine,:uom).where{
          (
            ( name =~  query )  | 
            ( base_sku =~ query ) | 
            ( description =~ query ) | 
            ( machine.name =~ query ) | 
            ( core_builder_type_case =~ query ) | 
            ( sku_used_core =~ query ) | 
            ( sku_new_core =~ query ) | 
            ( uom.name =~ query )
          )
        }.count
   
    else
      puts "In this shite"
      @objects = CoreBuilder.page(params[:page]).per(params[:limit]).order("id DESC")
      @total = CoreBuilder.count 
    end
    
    
    # render :json => { :core_builders => @objects , :total => @total , :success => true }
  end

  def create
    @object = CoreBuilder.create_object( params[:core_builder] )
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :core_builders => [@object] , 
                        :total => CoreBuilder.active_objects.count  }  
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
    @object = CoreBuilder.find(params[:id]) 
    

    @object.update_object( params[:core_builder] )
    
     
    if @object.errors.size == 0 
      @total = CoreBuilder.active_objects.count
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
    @object = CoreBuilder.find_by_id params[:id]
    @total = CoreBuilder.count
  end

  def destroy
    @object = CoreBuilder.find(params[:id])
    
    begin
      ActiveRecord::Base.transaction do 
        @object.delete_object 
      end
    rescue ActiveRecord::ActiveRecordError  
    else
    end
    
    

    if not @object.persisted?  
      render :json => { :success => true, :total => CoreBuilder.active_objects.count }  
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
      @objects = CoreBuilder.joins(:machine,:uom).where{ 
          ( name =~  query )  | 
          ( base_sku =~ query ) | 
          ( description =~ query ) | 
          ( machine.name=~ query ) | 
          ( core_builder_type_case =~ query ) | 
          ( sku_used_core =~ query ) | 
          ( sku_new_core =~ query ) | 
          ( uom.name =~ query )
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = CoreBuilder.joins(:machine,:uom).where{ 
        ( name =~  query )  | 
        ( base_sku =~ query ) | 
        ( description =~ query ) | 
        ( machine.name=~ query ) | 
        ( core_builder_type_case =~ query ) | 
        ( sku_used_core =~ query ) | 
        ( sku_new_core =~ query ) | 
        ( uom.name =~ query )
                              }.count
    else
      @objects = CoreBuilder.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = CoreBuilder.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
