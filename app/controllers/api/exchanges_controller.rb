class Api::ExchangesController < Api::BaseApiController
  
  def index
    
    
    

    puts "=======> This is the index from exchanges controller \n"*10
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
      @objects = Exchange.where{  
        
        ( name =~ livesearch  ) | 
        ( description =~ livesearch  )  
        
      }.page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = Exchange.where{ 
        ( name =~ livesearch  ) | 
        ( description =~ livesearch  )  
      }.count
      
      # calendar
      
    elsif params[:parent_id].present?
      # @group_loan = GroupLoan.find_by_id params[:parent_id]
      @objects = Exchange.
                  where(:exchange_id => params[:parent_id]).
                  page(params[:page]).per(params[:limit]).order("id DESC")
      @total = Exchange.where(:exchange_id => params[:parent_id]).count 
    else
      @objects = Exchange.page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = Exchange.count
    end
    
    
    
    
    
    # render :json => { :exchanges => @objects , :total => @total, :success => true }
  end

  def create
    @object = Exchange.create_object( params[:exchange] )  
    
    
 
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :exchanges => [@object] , 
                        :total => Exchange.active_objects.count }  
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
    
    @object = Exchange.find_by_id params[:id] 
    @object.update_object( params[:exchange])
     
    if @object.errors.size == 0 
      @total = Exchange.active_objects.count
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
    @object = Exchange.find(params[:id])
    @object.delete_object

    if not @object.persisted? 
      render :json => { :success => true, :total => Exchange.active_objects.count }  
    else
      render :json => { :success => false, :total => Exchange.active_objects.count }  
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
      @objects = Exchange.where{ 
            ( name =~ query  ) | 
        ( description =~ query  )  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = Exchange.where{ 
              ( name =~ query  ) | 
        ( description =~ query  )  
                              }.count
    else
      @objects = Exchange.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = Exchange.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
