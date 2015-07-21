class Api::PaymentRequestDetailsController < Api::BaseApiController
  
  def index
    @parent = PaymentRequest.find_by_id params[:payment_request_id]
    @objects = @parent.active_children.joins(:payment_request, :account).page(params[:page]).per(params[:limit]).order("id DESC")
    @total = @parent.active_children.count
  end

  def create
   
    @parent = PaymentRequest.find_by_id params[:payment_request_id]
    
  
    @object = PaymentRequestDetail.create_object(params[:payment_request_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :payment_request_details => [@object] , 
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
    @object = PaymentRequestDetail.find_by_id params[:id] 
    @parent = @object.payment_request 
    
    
    params[:payment_request_detail][:payment_request_id] = @parent.id  
    
    @object.update_object( params[:payment_request_detail])
     
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
    @object = PaymentRequestDetail.find(params[:id])
    @parent = @object.payment_request 
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
      @objects = PaymentRequestDetail.joins(:payment_request, :account).where{ 
        ( account.name  =~ query ) | 
        ( account.code =~ query ) | 
        ( code  =~ query  )  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = PaymentRequestDetail.joins(:payment_request, :account).where{ 
        ( account.name  =~ query ) | 
        ( account.code =~ query ) | 
        ( code  =~ query  )  
      }.count
    else
      @objects = PaymentRequestDetail.where{ 
              (id.eq selected_id)  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
   
      @total = PaymentRequestDetail.where{ 
              (id.eq selected_id)   
      }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
 
  
 
end
