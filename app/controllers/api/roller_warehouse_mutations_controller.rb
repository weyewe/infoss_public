class Api::RollerWarehouseMutationsController < Api::BaseApiController
  
  def index
     
     
     if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       @objects = RollerWarehouseMutation.active_objects.joins(:recovery_order).where{
         (
           ( code =~ livesearch)  | 
           ( recovery_order.code =~ livesearch)  
         )

       }.page(params[:page]).per(params[:limit]).order("id DESC")

       @total = RollerWarehouseMutation.active_objects.joins(:recovery_order).where{
         (
           ( code =~ livesearch)  | 
           ( recovery_order.code =~ livesearch)  
         )
       }.count
 

     else
       @objects = RollerWarehouseMutation.active_objects.joins(:recovery_order).page(params[:page]).per(params[:limit]).order("id DESC")
       @total = RollerWarehouseMutation.active_objects.count
     end
     
     
     
     
  end

  def create
    
    params[:roller_warehouse_mutation][:transaction_datetime] =  parse_date( params[:roller_warehouse_mutation][:transaction_datetime] )
    
    
    @object = RollerWarehouseMutation.create_object( params[:roller_warehouse_mutation])
 
    if @object.errors.size == 0 
      
      render :json => { :success => true, 
                        :roller_warehouse_mutations => [
                          :id => @object.id, 
                          :recovery_order_id => @object.recovery_order_id, 
                          :recovery_order_code => @object.recovery_order.code,
                          :code => @object.code, 
                          :warehouse_from_id => @object.warehouse_from_id, 
                          :warehouse_from_name => @object.warehouse_from.name, 
                          :warehouse_to_id => @object.warehouse_to_id, 
                          :warehouse_to_name => @object.warehouse_to.name, 
                          :amount => @object.amount, 
                          :mutation_date =>format_date_friendly(@object.mutation_date),
                          :is_confirmed => @object.is_confirmed,
                          :confirmed_at => format_date_friendly(@object.confirmed_at)  
                          ] , 
                        :total => RollerWarehouseMutation.active_objects.count }  
    else
      puts "It is fucking error!!\n"*10
      @object.errors.messages.each {|x| puts x }
      
      msg = {
        :success => false, 
        :message => {
          :errors => extjs_error_format( @object.errors ) 
          # :errors => {
          #   :name => "Nama tidak boleh bombastic"
          # }
        }
      }
      
      render :json => msg                         
    end
  end
  
  def show
    @object  = RollerWarehouseMutation.find params[:id]
    @total = RollerWarehouseMutation.active_objects.count
  end

  def update
    params[:roller_warehouse_mutation][:transaction_datetime] =  parse_date( params[:roller_warehouse_mutation][:transaction_datetime] )
    params[:roller_warehouse_mutation][:confirmed_at] =  parse_date( params[:roller_warehouse_mutation][:confirmed_at] )
    
    @object = RollerWarehouseMutation.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_role?( :roller_warehouse_mutations, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:roller_warehouse_mutation][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_role?( :roller_warehouse_mutations, :unconfirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.unconfirm_object
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
    else
      @object.update_object(params[:roller_warehouse_mutation])
    end
    
     
    
    
    
    
    if @object.errors.size == 0 
      @total = RollerWarehouseMutation.active_objects.count
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
    @object = RollerWarehouseMutation.find(params[:id])
    @object.delete_object

    if   not @object.persisted? 
      render :json => { :success => true, :total => RollerWarehouseMutation.active_objects.count }  
    else
      render :json => { :success => false, :total => RollerWarehouseMutation.active_objects.count, 
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
      @objects = RollerWarehouseMutation.active_objects.joins(:recovery_order).where{  
        ( 
           ( code =~ query )  
         )
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = RollerWarehouseMutation.active_objects.joins(:recovery_order).where{  
        ( 
           ( code =~ query )  
         )
      }.count 
    else
      @objects = RollerWarehouseMutation.active_objects.joins(:recovery_order).where{ 
          (id.eq selected_id)   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = RollerWarehouseMutation.active_objects.joins(:recovery_order).where{ 
          (id.eq selected_id)  
      }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
