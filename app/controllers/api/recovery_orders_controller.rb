class Api::RecoveryOrdersController < Api::BaseApiController
  
  def index
     
     
     if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       @objects = RecoveryOrder.active_objects.joins(:warehouse,:roller_identification_form).where{
         (
           ( code =~ livesearch)  | 
           ( roller_identification_form.nomor_disasembly =~  livesearch) | 
           ( warehouse.name =~  livesearch)
         )

       }.page(params[:page]).per(params[:limit]).order("id DESC")

       @total = RecoveryOrder.active_objects.joins(:warehouse,:roller_identification_form).where{
         (
           ( code =~ livesearch)  | 
           ( roller_identification_form.nomor_disasembly =~  livesearch) | 
           ( warehouse.name =~  livesearch)
         )
       }.count
 

     else
       @objects = RecoveryOrder.active_objects.joins(:warehouse,:roller_identification_form).page(params[:page]).per(params[:limit]).order("id DESC")
       @total = RecoveryOrder.active_objects.count
     end
     
     
     
     
  end

  def create
    
    # params[:recovery_order][:transaction_datetime] =  parse_date( params[:recovery_order][:transaction_datetime] )
    
    
    @object = RecoveryOrder.create_object( params[:recovery_order])
 
    if @object.errors.size == 0 
      
      render :json => { :success => true, 
                        :recovery_orders => [
                          :id => @object.id, 
                          :roller_identification_form_id => @object.roller_identification_form_id, 
                          :roller_identification_form_nomor_disasembly => @object.roller_identification_form.nomor_disasembly, 
                          :roller_identification_form_code => @object.roller_identification_form.code, 
                          :warehouse_id => @object.warehouse_id, 
                          :warehouse_name => @object.warehouse.name, 
                          :code => @object.code, 
                          :amount_received => @object.amount_received, 
                          :amount_rejected => @object.amount_rejected, 
                          :amount_final => @object.amount_final, 
                          :is_completed => @object.is_completed, 
                          :is_confirmed => @object.is_confirmed, 
                          :confirmed_at => format_date_friendly(@object.confirmed_at) , 
                          :has_due_date => @object.has_due_date, 
                          :due_date => format_date_friendly(@object.due_date) ,
                          ] , 
                        :total => RecoveryOrder.active_objects.count }  
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
    @object  = RecoveryOrder.find params[:id]
    @total = RecoveryOrder.active_objects.count
  end

  def update
    params[:recovery_order][:confirmed_at] =  parse_date( params[:recovery_order][:confirmed_at] )
    
    @object = RecoveryOrder.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_role?( :recovery_orders, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:recovery_order][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_role?( :recovery_orders, :unconfirm)
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
      @object.update_object(params[:recovery_order])
    end
    
     
    
    
    
    
    if @object.errors.size == 0 
      @total = RecoveryOrder.active_objects.count
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
    @object = RecoveryOrder.find(params[:id])
    @object.delete_object

    if   not @object.persisted? 
      render :json => { :success => true, :total => RecoveryOrder.active_objects.count }  
    else
      render :json => { :success => false, :total => RecoveryOrder.active_objects.count, 
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
      @objects = RecoveryOrder.active_objects.joins(:warehouse,:roller_identification_form).where{  
        ( 
           ( code =~ query)  | 
           ( roller_identification_form.nomor_disasembly =~  query) | 
           ( warehouse.name =~  query) 
         )
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = RecoveryOrder.active_objects.joins(:warehouse,:roller_identification_form).where{  
        ( 
           ( code =~ query)  | 
           ( roller_identification_form.nomor_disasembly =~  query) | 
           ( warehouse.name =~  query) 
         )
      }.count 
    else
      @objects = RecoveryOrder.active_objects.joins(:warehouse,:roller_identification_form).where{ 
          (id.eq selected_id)   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = RecoveryOrder.active_objects.joins(:warehouse,:roller_identification_form).where{ 
          (id.eq selected_id)  
      }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
