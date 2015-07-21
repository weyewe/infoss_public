class Api::UomsController < Api::BaseApiController
  
  def index
    
    
    

    
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
      @objects = Uom.where{  
        ( name =~ livesearch )
      }.page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = Uom.where{ 
        ( name =~ livesearch )
      }.count
      
      # calendar
      
    elsif params[:parent_id].present?
      # @group_loan = GroupLoan.find_by_id params[:parent_id]
      @objects = Uom.
                  where(:uom_id => params[:parent_id]).
                  page(params[:page]).per(params[:limit]).order("id DESC")
      @total = Uom.where(:uom_id => params[:parent_id]).count 
    else
      @objects = Uom.page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = Uom.count
    end
    
    
    
    
    
    # render :json => { :uoms => @objects , :total => @total, :success => true }
  end

  def create
    @object = Uom.create_object( params[:uom] )  
    
    
 
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :uoms => [@object] , 
                        :total => Uom.active_objects.count }  
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
    
    @object = Uom.find_by_id params[:id] 
    @object.update_object( params[:uom])
     
    if @object.errors.size == 0 
      @total = Uom.active_objects.count
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
    @object = Uom.find(params[:id])
    @object.delete_object

    if not @object.persisted?
      render :json => { :success => true, :total => Uom.active_objects.count }  
    else
      render :json => { :success => false, :total => Uom.active_objects.count }  
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
      @objects = Uom.where{ 
                            ( name =~ query )
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = Uom.where{ 
              ( name =~ query )
                              }.count
    else
      @objects = Uom.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = Uom.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
