class Api::WarehouseMutationDetailsController < Api::BaseApiController
  
  def index
    @parent = WarehouseMutation.find_by_id params[:warehouse_mutation_id]
    @objects = @parent.active_children.joins(:warehouse_mutation, :item => [:uom]).page(params[:page]).per(params[:limit]).order("id DESC")
    @total = @parent.active_children.count
  end

  def create
   
    @parent = WarehouseMutation.find_by_id params[:warehouse_mutation_id]
    
  
    @object = WarehouseMutationDetail.create_object(params[:warehouse_mutation_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :warehouse_mutation_details => [@object] , 
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
    @object = WarehouseMutationDetail.find_by_id params[:id] 
    @parent = @object.warehouse_mutation 
    
    
    params[:warehouse_mutation_detail][:warehouse_mutation_id] = @parent.id  
    
    @object.update_object( params[:warehouse_mutation_detail])
     
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
    @object = WarehouseMutationDetail.find(params[:id])
    @parent = @object.warehouse_mutation 
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
