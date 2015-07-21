class Api::ReceiptVoucherDetailsController < Api::BaseApiController
  
  def index
    @parent = ReceiptVoucher.find_by_id params[:receipt_voucher_id]
    @objects = @parent.active_children.joins(:receipt_voucher, :receivable).page(params[:page]).per(params[:limit]).order("id DESC")
    @total = @parent.active_children.count
  end

  def create
   
    @parent = ReceiptVoucher.find_by_id params[:receipt_voucher_id]
    
  
    @object = ReceiptVoucherDetail.create_object(params[:receipt_voucher_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :receipt_voucher_details => [@object] , 
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
    @object = ReceiptVoucherDetail.find_by_id params[:id] 
    @parent = @object.receipt_voucher 
    
    
    params[:receipt_voucher_detail][:receipt_voucher_id] = @parent.id  
    
    @object.update_object( params[:receipt_voucher_detail])
     
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
    @object = ReceiptVoucherDetail.find(params[:id])
    @parent = @object.receipt_voucher 
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
      @objects = ReceiptVoucherDetail.joins(:receipt_voucher, :receivable).where{ 
        (receivable.receivable_source_code  =~ query  )   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = ReceiptVoucherDetail.joins(:receipt_voucher, :receivable).where{ 
        (receivable.receivable_source_code  =~ query  ) 
      }.count
    else
      @objects = ReceiptVoucherDetail.where{ 
              (id.eq selected_id)  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
   
      @total = ReceiptVoucherDetail.where{ 
              (id.eq selected_id)   
      }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
 
  
 
end
