class Api::BlendingRecipeDetailsController < Api::BaseApiController
  
  def index
    @parent = BlendingRecipe.find_by_id params[:blending_recipe_id]
    @objects = @parent.active_children.joins(:blending_recipe, :item => [:uom]).page(params[:page]).per(params[:limit]).order("id DESC")
    @total = @parent.active_children.count
  end

  def create
   
    @parent = BlendingRecipe.find_by_id params[:blending_recipe_id]
    
  
    @object = BlendingRecipeDetail.create_object(params[:blending_recipe_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :blending_recipe_details => [@object] , 
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
    @object = BlendingRecipeDetail.find_by_id params[:id] 
    @parent = @object.blending_recipe 
    
    
    params[:blending_recipe_detail][:blending_recipe_id] = @parent.id  
    
    @object.update_object( params[:blending_recipe_detail])
     
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
    @object = BlendingRecipeDetail.find(params[:id])
    @parent = @object.blending_recipe 
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
      @objects = BlendingRecipeDetail.joins(:blending_recipe, :item => [:uom]).where{ 
        ( item.sku  =~ query ) | 
        ( item.name =~ query ) | 
        ( item.uom.name  =~ query  )   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = BlendingRecipeDetail.joins(:blending_recipe, :item => [:uom]).where{ 
        ( item.sku  =~ query ) | 
        ( item.name =~ query ) | 
        ( item.uom.name  =~ query  )   
      }.count
    else
      @objects = BlendingRecipeDetail.where{ 
              (id.eq selected_id)  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
   
      @total = BlendingRecipeDetail.where{ 
              (id.eq selected_id)   
      }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
 
  
 
end
