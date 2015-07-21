class Api::ExchangeRatesController < Api::BaseApiController
  
  def index
    
    
    

    puts "=======> This is the index from exchange_rates controller \n"*10
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
      
      
      if params[:parent_id].present?
        selected_parent_id = params[:parent_id]
        @objects = ExchangeRate.joins(:exchange).where{  
          ( exchange_id.eq selected_parent_id ) & 
          ( exchange.name =~ livesearch  )  
          
        }.page(params[:page]).per(params[:limit]).order("id DESC")
        
        @total = ExchangeRate.joins(:exchange).where{ 
          ( exchange_id.eq selected_parent_id ) & 
          ( exchange.name =~ livesearch  )  
        }.count
      else
        @objects = ExchangeRate.joins(:exchange).where{  
        
          ( exchange.name =~ livesearch  )  
          
        }.page(params[:page]).per(params[:limit]).order("id DESC")
        
        @total = ExchangeRate.joins(:exchange).where{ 
          ( exchange.name =~ livesearch  )  
        }.count
      end
       
      
    elsif params[:parent_id].present?
      # @group_loan = GroupLoan.find_by_id params[:parent_id]
      @objects = ExchangeRate.
                  where(:exchange_id => params[:parent_id]).
                  page(params[:page]).per(params[:limit]).order("id DESC")
      @total = ExchangeRate.where(:exchange_id => params[:parent_id]).count 
    else
      @objects = ExchangeRate.page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = ExchangeRate.count
    end
    
    
    
    
    
    # render :json => { :exchange_rates => @objects , :total => @total, :success => true }
  end

  def create
    params[:exchange_rate][:ex_rate_date] =  parse_date( params[:exchange_rate][:ex_rate_date] ) 
    @object = ExchangeRate.create_object( params[:exchange_rate] )  
    
    
 
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :exchange_rates => [@object] , 
                        :total => ExchangeRate.active_objects.count }  
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
    
    @object = ExchangeRate.find_by_id params[:id] 
    params[:exchange_rate][:ex_rate_date] =  parse_date( params[:exchange_rate][:ex_rate_date] ) 
    @object.update_object( params[:exchange_rate])
     
    if @object.errors.size == 0 
      @total = ExchangeRate.active_objects.count
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
    @object = ExchangeRate.find(params[:id])
    @object.delete_object

    if not @object.persisted? 
      render :json => { :success => true, :total => ExchangeRate.active_objects.count }  
    else
      render :json => { :success => false, :total => ExchangeRate.active_objects.count }  
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
      @objects = ExchangeRate.joins(:exchange).where{ 
            ( exchange.name =~ query  )  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = ExchangeRate.joins(:exchange).where{ 
              ( exchange.name =~ query  ) 
                              }.count
    else
      @objects = ExchangeRate.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = ExchangeRate.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
