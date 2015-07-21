class Api::RollerAccDetailsController < Api::BaseApiController
  
  def index
    @parent = RollerIdentificationFormDetail.find_by_id params[:roller_identification_form_detail_id]
    @objects = @parent.active_children.joins(:roller_identification_form_detail, :item).page(params[:page]).per(params[:limit]).order("id DESC")
    @total = @parent.active_children.count
  end

  def create
   
    @parent = RollerIdentificationFormDetail.find_by_id params[:roller_identification_form_detail_id]
    
  
    @object = RollerAccessoryDetail.create_object(params[:roller_accessory_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :roller_accessory_details => [@object] , 
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
    @object = RollerAccessoryDetail.find_by_id params[:id] 
    @parent = @object.roller_acc 
    
    
    params[:roller_acc_detail][:roller_acc_id] = @parent.id  
    
    @object.update_object( params[:roller_accessory_details])
     
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
    @object = RollerAccessoryDetail.find(params[:id])
    @parent = @object.roller_acc 
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
      @objects = RollerAccessoryDetail.joins(:roller_identification_form_detail, :item).where{ 
        ( item.sku  =~ query ) | 
        ( item.name =~ query ) | 
        ( item.description  =~ query  )  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = RollerAccessoryDetail.joins(:roller_identification_form_detail, :item).where{ 
        ( item.sku  =~ query ) | 
        ( item.name =~ query ) | 
        ( item.description  =~ query  )  
      }.count
    else
      @objects = RollerAccessoryDetail.where{ 
              (id.eq selected_id)  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
   
      @total = RollerAccessoryDetail.where{ 
              (id.eq selected_id)   
      }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
 
  
 
end
