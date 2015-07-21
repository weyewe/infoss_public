class Api::VirtualDeliveryOrdersController < Api::BaseApiController
  
  def index
     
     
     if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       @objects = VirtualDeliveryOrder.active_objects.joins(:warehouse,:virtual_order).where{
         (
           ( nomor_surat =~  livesearch ) | 
           ( code =~ livesearch)  | 
           ( warehouse.name =~  livesearch) |
           ( virtual_order.code =~  livesearch) |
          # ( virtual_order.contact.name =~  livesearch) |
           ( virtual_order.nomor_surat =~  livesearch)
         )

       }.page(params[:page]).per(params[:limit]).order("id DESC")

       @total = VirtualDeliveryOrder.active_objects.joins(:warehouse,:virtual_order).where{
         (
           ( nomor_surat =~  livesearch ) | 
           ( code =~ livesearch)  | 
           ( warehouse.name =~  livesearch) |
           ( virtual_order.code =~  livesearch) |
          # ( virtual_order.contact.name =~  livesearch) |
           ( virtual_order.nomor_surat =~  livesearch)
         )
       }.count
 

     else
       @objects = VirtualDeliveryOrder.active_objects.joins(:warehouse,:virtual_order).page(params[:page]).per(params[:limit]).order("id DESC")
       @total = VirtualDeliveryOrder.active_objects.count
     end
     
     
     
     
  end

  def create
    
    params[:virtual_delivery_order][:delivery_date] =  parse_date( params[:virtual_delivery_order][:delivery_date] )
    
    
    @object = VirtualDeliveryOrder.create_object( params[:virtual_delivery_order])
 
    if @object.errors.size == 0 
      
      render :json => { :success => true, 
                        :virtual_delivery_orders => [
                          :id => @object.id, 
                          :code => @object.code ,
                          :nomor_surat => @object.nomor_surat ,
                          :warehouse_id => @object.warehouse_id,
                          :warehouse_name => @object.warehouse.name, 
                          :virtual_order_code => @object.virtual_order.code,
                          :contact_name => @object.virtual_order.contact.name,
                          :virtual_order_id => @object.virtual_order.id ,
                          :delivery_date => format_date_friendly(@object.delivery_date)  ,
                          :is_confirmed => @object.is_confirmed,
                          :confirmed_at => format_date_friendly(@object.confirmed_at) 
                          ] , 
                        :total => VirtualDeliveryOrder.active_objects.count }  
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
    @object  = VirtualDeliveryOrder.find params[:id]
    @total = VirtualDeliveryOrder.active_objects.count
  end

  def update
    params[:virtual_delivery_order][:transaction_datetime] =  parse_date( params[:virtual_delivery_order][:transaction_datetime] )
    params[:virtual_delivery_order][:confirmed_at] =  parse_date( params[:virtual_delivery_order][:confirmed_at] )
    
    @object = VirtualDeliveryOrder.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_role?( :virtual_delivery_orders, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:virtual_delivery_order][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_role?( :virtual_delivery_orders, :unconfirm)
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
      @object.update_object(params[:virtual_delivery_order])
    end
    
     
    
    
    
    
    if @object.errors.size == 0 
      @total = VirtualDeliveryOrder.active_objects.count
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
    @object = VirtualDeliveryOrder.find(params[:id])
    @object.delete_object

    if   not @object.persisted? 
      render :json => { :success => true, :total => VirtualDeliveryOrder.active_objects.count }  
    else
      render :json => { :success => false, :total => VirtualDeliveryOrder.active_objects.count, 
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
      @objects = VirtualDeliveryOrder.active_objects.joins(:warehouse,:virtual_order).where{  
        ( 
           ( nomor_surat =~  query ) | 
           ( code =~ query)  | 
           ( warehouse.name =~  query) |
           ( virtual_order.code =~  query) |
          # ( virtual_order.contact.name =~  query) |
           ( virtual_order.nomor_surat =~  query)
         )
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = VirtualDeliveryOrder.active_objects.joins(:warehouse,:virtual_order).where{  
        ( 
           ( nomor_surat =~  query ) | 
           ( code =~ query)  | 
           ( warehouse.name =~  query) |
           ( virtual_order.code =~  query) |
          # ( virtual_order.contact.name =~  query) |
           ( virtual_order.nomor_surat =~  query)
         )
      }.count 
    else
      @objects = VirtualDeliveryOrder.active_objects.joins(:warehouse,:virtual_order).where{ 
          (id.eq selected_id)   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = VirtualDeliveryOrder.active_objects.joins(:warehouse,:virtual_order).where{ 
          (id.eq selected_id)  
      }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
