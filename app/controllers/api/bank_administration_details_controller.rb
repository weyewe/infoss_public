class Api::BankAdministrationDetailsController < Api::BaseApiController
  
  def index
    @parent = BankAdministration.find_by_id params[:bank_administration_id]
    @objects = @parent.active_children.joins(:bank_administration, :account).page(params[:page]).per(params[:limit]).order("id DESC")
    @total = @parent.active_children.count
  end

  def create
   
    @parent = BankAdministration.find_by_id params[:bank_administration_id]
    
  
    @object = BankAdministrationDetail.create_object(params[:bank_administration_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :bank_administration_details => [@object] , 
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
    @object = BankAdministrationDetail.find_by_id params[:id] 
    @parent = @object.bank_administration 
    
    
    params[:bank_administration_detail][:bank_administration_id] = @parent.id  
    
    @object.update_object( params[:bank_administration_detail])
     
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :bank_administration_details => [@object],
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
    @object = BankAdministrationDetail.find(params[:id])
    @parent = @object.bank_administration 
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
      @objects = BankAdministrationDetail.joins(:bank_administration, :account).where{ 
        ( account.name  =~ query ) | 
        ( description  =~ query ) | 
        ( code  =~ query  )  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = BankAdministrationDetail.joins(:bank_administration, :account).where{ 
        ( account.name  =~ query ) | 
        ( description  =~ query ) | 
        ( code  =~ query  )  
      }.count
    else
      @objects = BankAdministrationDetail.joins(:bank_administration, :account).where{ 
              (id.eq selected_id)  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
   
      @total = BankAdministrationDetail.joins(:bank_administration, :account).where{ 
              (id.eq selected_id)   
      }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
 
  
 
end
