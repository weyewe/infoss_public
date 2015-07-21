class Api::SalesDownPaymentAllocationDetailsController < Api::BaseApiController
  
  def index
    @parent = SalesDownPaymentAllocation.find_by_id params[:sales_down_payment_allocation_id]
    @objects = @parent.active_children.joins(:sales_down_payment_allocation, :receivable).page(params[:page]).per(params[:limit]).order("id DESC")
    @total = @parent.active_children.count
  end

  def create
   
    @parent = SalesDownPaymentAllocation.find_by_id params[:sales_down_payment_allocation_id]
    
  
    @object = SalesDownPaymentAllocationDetail.create_object(params[:sales_down_payment_allocation_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :sales_down_payment_allocation_details => [@object] , 
                        :total => @parent.active_children.count }  
    else
      msg = {
        :success => false, 
        :message => {
          :errors => extjs_error_format( @object.errors )  
        }
      }
      
      render :json => msg                         
    end
  end

  def update
    @object = SalesDownPaymentAllocationDetail.find_by_id params[:id] 
    @parent = @object.sales_down_payment_allocation 
    
    
    params[:sales_down_payment_allocation_detail][:sales_down_payment_allocation_id] = @parent.id  
    
    @object.update_object( params[:sales_down_payment_allocation_detail])
     
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :sales_down_payment_allocation_details => [@object],
                        :total => @parent.active_children.count  } 
    else
      msg = {
        :success => false, 
        :message => {
          :errors => extjs_error_format( @object.errors )  
        }
      }
      
      render :json => msg 
    end
  end

  def destroy
    @object = SalesDownPaymentAllocationDetail.find(params[:id])
    @parent = @object.sales_down_payment_allocation 
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
      @objects = SalesDownPaymentAllocationDetail.joins(:sales_down_payment_allocation, :receivable).where{ 
        ( receivable.source_code  =~ query  )  | 
        ( code  =~ query  )  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = SalesDownPaymentAllocationDetail.joins(:sales_down_payment_allocation, :receivable).where{ 
         ( receivable.source_code  =~ query  )  | 
        ( code  =~ query  )  
      }.count
    else
      @objects = SalesDownPaymentAllocationDetail.joins(:sales_down_payment_allocation, :receivable).where{ 
              (id.eq selected_id)  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
   
      @total = SalesDownPaymentAllocationDetail.joins(:sales_down_payment_allocation, :receivable).where{ 
              (id.eq selected_id)   
      }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
 
  
 
end
