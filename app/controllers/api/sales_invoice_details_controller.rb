class Api::SalesInvoiceDetailsController < Api::BaseApiController
  
  def index
    @parent = SalesInvoice.find_by_id params[:sales_invoice_id]
    @objects = @parent.active_children.joins(:sales_invoice, :delivery_order_detail => [:item => [:uom]] ).page(params[:page]).per(params[:limit]).order("id DESC")
    @total = @parent.active_children.count
  end

  def create
   
    @parent = SalesInvoice.find_by_id params[:sales_invoice_id]
    
  
    @object = SalesInvoiceDetail.create_object(params[:sales_invoice_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :sales_invoice_details => [@object] , 
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
    @object = SalesInvoiceDetail.find_by_id params[:id] 
    @parent = @object.sales_invoice 
    
    
    params[:sales_invoice_detail][:sales_invoice_id] = @parent.id  
    
    @object.update_object( params[:sales_invoice_detail])
     
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
    @object = SalesInvoiceDetail.find(params[:id])
    @parent = @object.sales_invoice 
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
   
 
end
