class Api::BlendingWorkOrdersController < Api::BaseApiController
  
  def index
     
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
        
        
        @objects = BlendingWorkOrder.joins(:warehouse,:blending_recipe).where{
          (
            ( code =~  livesearch )  | 
            ( warehouse.name =~ livesearch ) | 
            ( blending_recipe.name =~ livesearch ) | 
            ( blending_recipe.target_item.sku =~ livesearch ) | 
            ( blending_recipe.target_item.name =~ livesearch ) | 
            ( blending_recipe.target_item.uom.name =~ livesearch ) | 
            ( description =~ livesearch )
          )

        }.page(params[:page]).per(params[:limit]).order("id DESC")

        @total = BlendingWorkOrder.joins(:warehouse,:blending_recipe).where{
          (
            ( code =~  livesearch )  | 
            ( warehouse.name =~ livesearch ) | 
            ( blending_recipe.name =~ livesearch ) | 
            ( blending_recipe.target_item.sku =~ livesearch ) | 
            ( blending_recipe.target_item.name =~ livesearch ) | 
            ( blending_recipe.target_item.uom.name =~ livesearch ) | 
            ( description =~ livesearch )
          )
        }.count
   
    else
      puts "In this shite"
      @objects = BlendingWorkOrder.page(params[:page]).per(params[:limit]).order("id DESC")
      @total = BlendingWorkOrder.count 
    end
    
    
    # render :json => { :blending_work_orders => @objects , :total => @total , :success => true }
  end

  def create
    params[:blending_work_order][:blending_date] =  parse_date( params[:blending_work_order][:blending_date] )
    @object = BlendingWorkOrder.create_object( params[:blending_work_order] )
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :blending_work_orders => [@object] , 
                        :total => BlendingWorkOrder.active_objects.count  }  
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
    params[:blending_work_order][:blending_date] =  parse_date( params[:blending_work_order][:blending_date] )
    params[:blending_work_order][:confirmed_at] =  parse_date( params[:blending_work_order][:confirmed_at] )
    
    @object = BlendingWorkOrder.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_role?( :blending_work_orders, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:blending_work_order][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_role?( :blending_work_orders, :unconfirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.unconfirm_object
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
    else
      @object.update_object(params[:blending_work_order])
    end
    
     
     
    if @object.errors.size == 0 
      @total = BlendingWorkOrder.active_objects.count
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
    @object = BlendingWorkOrder.find_by_id params[:id]
    @total = BlendingWorkOrder.count
  end

  def destroy
    @object = BlendingWorkOrder.find(params[:id])
    
    begin
      ActiveRecord::Base.transaction do 
        @object.delete_object 
      end
    rescue ActiveRecord::ActiveRecordError  
    else
    end
    
    

    if not @object.persisted?  
      render :json => { :success => true, :total => BlendingWorkOrder.active_objects.count }  
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
      @objects = BlendingWorkOrder.joins(:warehouse,:blending_recipe).where{ 
          ( code =~  query )  | 
          ( warehouse.name =~ query ) | 
          ( blending_recipe.name =~ query ) | 
          ( blending_recipe.target_item.sku =~ query ) | 
          ( blending_recipe.target_item.name =~ query ) | 
          ( blending_recipe.target_item.uom.name =~ query ) | 
          ( description =~ query )
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = BlendingWorkOrder.joins(:warehouse,:blending_recipe).where{ 
          ( code =~  query )  | 
          ( warehouse.name =~ query ) | 
          ( blending_recipe.name =~ query ) | 
          ( blending_recipe.target_item.sku =~ query ) | 
          ( blending_recipe.target_item.name =~ query ) | 
          ( blending_recipe.target_item.uom.name =~ query ) | 
          ( description =~ query )
        
                              }.count
    else
      @objects = BlendingWorkOrder.joins(:warehouse,:blending_recipe).where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = BlendingWorkOrder.joins(:warehouse,:blending_recipe).where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
