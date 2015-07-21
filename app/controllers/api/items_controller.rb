class Api::ItemsController < Api::BaseApiController
  
  def index
     
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
      @objects = Item.joins(:exchange, :item_type, :uom).where{  
        
        ( sku =~ livesearch ) | 
        ( name =~ livesearch ) | 
        ( description  =~ livesearch  )  
        
      }.page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = Item.joins(:exchange, :item_type, :uom).where{ 
        ( sku =~ livesearch ) | 
        ( name =~ livesearch ) | 
        ( description  =~ livesearch  )   
      }.count
      
      # calendar
      
    elsif params[:parent_id].present?
      # @group_loan = GroupLoan.find_by_id params[:parent_id]
      @objects = Item.
                  where(:item_id => params[:parent_id]).
                  page(params[:page]).per(params[:limit]).order("id DESC")
      @total = Item.where(:item_id => params[:parent_id]).count 
    else
      @objects = Item.joins(:exchange, :item_type, :uom).page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = Item.count
    end
    
    
    
    
    
    # render :json => { :items => @objects , :total => @total, :success => true }
  end

  def create
    @object = Item.create_object( params[:item] )  
    
    
 
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :items => [@object] , 
                        :total => Item.active_objects.count }  
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
    
    @object = Item.find_by_id params[:id] 
    @object.update_object( params[:item])
     
    if @object.errors.size == 0 
      @total = Item.active_objects.count
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
    @object = Item.find(params[:id])
    @object.delete_object

    if not @object.persisted? 
      render :json => { :success => true, :total => Item.active_objects.count }  
    else
      render :json => { :success => false, :total => Item.active_objects.count }  
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
      query_code =  Item.joins(:exchange, :item_type, :uom).where{ 
                   ( sku  =~ query ) | 
                   ( name =~ query ) | 
                   ( description  =~ query  )  
                }
                
      if params[:is_batch].present?
        query_code = query_code.where{
          
          item_type.is_batched.eq true 
        }
      end
      
      if params[:is_accessory].present?
        accessory_item_type = ItemType.find_by_name BASE_ITEM_TYPE[:accessory]
        query_code = query_code.where{
          
          item_type.id.eq accessory_item_type.id  
        }
      end
      
      @objects = query_code.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = query_code.count
    else
      @objects = Item.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = Item.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
  
  def search_compound
    search_params = params[:query]
    selected_id = params[:selected_id]
    if params[:selected_id].nil?  or params[:selected_id].length == 0 
      selected_id = nil
    end
    
    query = "%#{search_params}%"
    # on PostGre SQL, it is ignoring lower case or upper case 
    
    if  selected_id.nil?
      @objects = Item.compounds.joins(:exchange, :item_type, :uom).where{ 
            ( sku  =~ query ) | 
        ( name =~ query ) | 
        ( description  =~ query  )  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = Item.compounds.joins(:exchange, :item_type, :uom).where{ 
               ( sku  =~ query ) | 
        ( name =~ query ) | 
        ( description  =~ query  )  
                              }.count
    else
      @objects = Item.compounds.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = Item.compounds.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
  
  def search_adhesive_roller
    search_params = params[:query]
    selected_id = params[:selected_id]
    if params[:selected_id].nil?  or params[:selected_id].length == 0 
      selected_id = nil
    end
    
    query = "%#{search_params}%"
    # on PostGre SQL, it is ignoring lower case or upper case 
    
    if  selected_id.nil?
      @objects = Item.adhesive_rollers.joins(:exchange, :item_type, :uom).where{ 
            ( sku  =~ query ) | 
        ( name =~ query ) | 
        ( description  =~ query  )  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = Item.adhesive_rollers.joins(:exchange, :item_type, :uom).where{ 
               ( sku  =~ query ) | 
        ( name =~ query ) | 
        ( description  =~ query  )  
                              }.count
    else
      @objects = Item.adhesive_rollers.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = Item.adhesive_rollers.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
  
  def search_adhesive_blanket
    search_params = params[:query]
    selected_id = params[:selected_id]
    if params[:selected_id].nil?  or params[:selected_id].length == 0 
      selected_id = nil
    end
    
    query = "%#{search_params}%"
    # on PostGre SQL, it is ignoring lower case or upper case 
    
    if  selected_id.nil?
      @objects = Item.adhesive_blankets.joins(:exchange, :item_type, :uom).where{ 
            ( sku  =~ query ) | 
        ( name =~ query ) | 
        ( description  =~ query  )  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = Item.adhesive_blankets.joins(:exchange, :item_type, :uom).where{ 
               ( sku  =~ query ) | 
        ( name =~ query ) | 
        ( description  =~ query  )  
                              }.count
    else
      @objects = Item.adhesive_blankets.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = Item.adhesive_blankets.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
  
  def search_roll_blanket
    search_params = params[:query]
    selected_id = params[:selected_id]
    if params[:selected_id].nil?  or params[:selected_id].length == 0 
      selected_id = nil
    end
    
    query = "%#{search_params}%"
    # on PostGre SQL, it is ignoring lower case or upper case 
    
    if  selected_id.nil?
      @objects = Item.roll_blankets.joins(:exchange, :item_type, :uom).where{ 
            ( sku  =~ query ) | 
        ( name =~ query ) | 
        ( description  =~ query  )  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = Item.adhesive_rollers.joins(:exchange, :item_type, :uom).where{ 
               ( sku  =~ query ) | 
        ( name =~ query ) | 
        ( description  =~ query  )  
                              }.count
    else
      @objects = Item.adhesive_rollers.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = Item.adhesive_rollers.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
  
  def search_bar
    search_params = params[:query]
    selected_id = params[:selected_id]
    if params[:selected_id].nil?  or params[:selected_id].length == 0 
      selected_id = nil
    end
    
    query = "%#{search_params}%"
    # on PostGre SQL, it is ignoring lower case or upper case 
    
    if  selected_id.nil?
      @objects = Item.bars.joins(:exchange, :item_type, :uom).where{ 
            ( sku  =~ query ) | 
        ( name =~ query ) | 
        ( description  =~ query  )  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = Item.adhesive_rollers.joins(:exchange, :item_type, :uom).where{ 
               ( sku  =~ query ) | 
        ( name =~ query ) | 
        ( description  =~ query  )  
                              }.count
    else
      @objects = Item.adhesive_rollers.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = Item.adhesive_rollers.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
  
end
