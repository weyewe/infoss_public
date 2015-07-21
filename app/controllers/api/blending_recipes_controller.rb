class Api::BlendingRecipesController < Api::BaseApiController
  
  def index
     
     
     if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       @objects = BlendingRecipe.active_objects.where{
         (
           
           ( name =~ livesearch)  | 
           ( description =~ livesearch)  
          # ( target_item.name =~  livesearch) | 
          # ( target_item.sku =~  livesearch) | 
          # ( target_item.amount =~  livesearch) |
          # ( target_item.uom.name =~  livesearch)
         )

       }.page(params[:page]).per(params[:limit]).order("id DESC")

       @total = BlendingRecipe.active_objects.where{
         (
            
           ( name =~ livesearch)  | 
           ( description =~ livesearch)  
          # ( target_item.name =~  livesearch) | 
          # ( target_item.sku =~  livesearch) | 
          # ( target_item.amount =~  livesearch) |
          # ( target_item.uom.name =~  livesearch)
         )
       }.count
 

     else
       @objects = BlendingRecipe.active_objects.page(params[:page]).per(params[:limit]).order("id DESC")
       @total = BlendingRecipe.active_objects.count
     end
     
     
     
     
  end

  def create
    
    
    
    @object = BlendingRecipe.create_object( params[:blending_recipe])
 
    if @object.errors.size == 0 
      
      render :json => { :success => true, 
                        :blending_recipes => [
                          :id => @object.id, 
                          :name => @object.name ,
                          :description => @object.description , 
                          :target_item_id => @object.target_item_id  ,
                          :target_amount => @object.target_amount,
                          ] , 
                        :total => BlendingRecipe.active_objects.count }  
    else
      puts "It is fucking error!!\n"*10
      @object.errors.messages.each {|x| puts x }
      
      msg = {
        :success => false, 
        :message => {
          :errors => extjs_error_format( @object.errors ) 
          # :errors => {
          #   :name => "Nama tidak boleh bombastic"
          # }
        }
      }
      
      render :json => msg                         
    end
  end
  
  def show
    @object  = BlendingRecipe.find params[:id]
    @total = BlendingRecipe.active_objects.count
  end

  def update
    
    @object = BlendingRecipe.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_role?( :blending_recipes, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:blending_recipe][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_role?( :blending_recipes, :unconfirm)
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
      @object.update_object(params[:blending_recipe])
    end
    
     
    
    
    
    
    if @object.errors.size == 0 
      @total = BlendingRecipe.active_objects.count
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
    @object = BlendingRecipe.find(params[:id])
    @object.delete_object

    if   not @object.persisted? 
      render :json => { :success => true, :total => BlendingRecipe.active_objects.count }  
    else
      render :json => { :success => false, :total => BlendingRecipe.active_objects.count, 
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
      @objects = BlendingRecipe.where{  
        ( 
           ( name =~ query)  | 
           ( description =~ query)  
          # ( target_item.name =~  query) | 
          # ( target_item.sku =~  query) | 
          # ( target_item.amount =~  query) |
          # ( target_item.uom.name =~  query)
         )
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = BlendingRecipe.where{  
        ( 
           ( name =~ query)  | 
           ( description =~ query)  
          # ( target_item.name =~  query) | 
          # ( target_item.sku =~  query) | 
          # ( target_item.amount =~  query) |
          # ( target_item.uom.name =~  query)
         )
      }.count 
    else
      @objects = BlendingRecipe.where{ 
          (id.eq selected_id)   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = BlendingRecipe.where{ 
          (id.eq selected_id)  
      }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
