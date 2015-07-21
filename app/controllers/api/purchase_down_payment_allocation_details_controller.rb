class Api::PurchaseDownPaymentAllocationDetailsController < Api::BaseApiController
  
  def index
    @parent = PurchaseDownPaymentAllocation.find_by_id params[:purchase_down_payment_allocation_id]
    @objects = @parent.active_children.joins(:purchase_down_payment_allocation, :payable).page(params[:page]).per(params[:limit]).order("id DESC")
    @total = @parent.active_children.count
  end

  def create
   
    @parent = PurchaseDownPaymentAllocation.find_by_id params[:purchase_down_payment_allocation_id]
    
  
    @object = PurchaseDownPaymentAllocationDetail.create_object(params[:purchase_down_payment_allocation_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :purchase_down_payment_allocation_details => [@object] , 
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
    @object = PurchaseDownPaymentAllocationDetail.find_by_id params[:id] 
    @parent = @object.purchase_down_payment_allocation 
    
    
    params[:purchase_down_payment_allocation_detail][:purchase_down_payment_allocation_id] = @parent.id  
    
    @object.update_object( params[:purchase_down_payment_allocation_detail])
     
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :purchase_down_payment_allocation_details => [@object],
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
    @object = PurchaseDownPaymentAllocationDetail.find(params[:id])
    @parent = @object.purchase_down_payment_allocation 
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
      @objects = PurchaseDownPaymentAllocationDetail.joins(:purchase_down_payment_allocation, :payable).where{ 
        ( payable.source_code  =~ query  )  | 
        ( code  =~ query  )  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = PurchaseDownPaymentAllocationDetail.joins(:purchase_down_payment_allocation, :payable).where{ 
        ( payable.source_code  =~ query  )  | 
        ( code  =~ query  ) 
      }.count
    else
      @objects = PurchaseDownPaymentAllocationDetail.joins(:purchase_down_payment_allocation, :payable).where{ 
              (id.eq selected_id)  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
   
      @total = PurchaseDownPaymentAllocationDetail.joins(:purchase_down_payment_allocation, :payable).where{ 
              (id.eq selected_id)   
      }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
 
  
 
end
