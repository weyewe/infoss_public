class Api::StockAdjustmentDetailsController < Api::BaseApiController
  
  def index
    @parent = StockAdjustment.find_by_id params[:stock_adjustment_id]
    @objects = @parent.active_children.joins(:stock_adjustment, :item => [:uom]).page(params[:page]).per(params[:limit]).order("id DESC")
    @total = @parent.active_children.count
  end

  def create
   
    @parent = StockAdjustment.find_by_id params[:stock_adjustment_id]
    
  
    @object = StockAdjustmentDetail.create_object(params[:stock_adjustment_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :stock_adjustment_details => [@object] , 
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
    @object = StockAdjustmentDetail.find_by_id params[:id] 
    @parent = @object.stock_adjustment 
    
    
    params[:stock_adjustment_detail][:stock_adjustment_id] = @parent.id  
    
    @object.update_object( params[:stock_adjustment_detail])
     
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
    @object = StockAdjustmentDetail.find(params[:id])
    @parent = @object.stock_adjustment 
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
