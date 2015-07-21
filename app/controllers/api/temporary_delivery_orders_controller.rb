class Api::TemporaryDeliveryOrdersController < Api::BaseApiController
  
  def index
     
     
     if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       @objects = TemporaryDeliveryOrder.active_objects.joins(:delivery_order,:warehouse).where{
         (
           ( code =~ livesearch)  | 
           ( nomor_surat =~ livesearch)  | 
           ( delivery_order.nomor_surat =~ livesearch)  | 
           ( delivery_order.sales_order.contact.name =~ livesearch)  | 
           ( warehouse.name =~  livesearch) 
         )

       }.page(params[:page]).per(params[:limit]).order("id DESC")

       @total = TemporaryDeliveryOrder.active_objects.joins(:delivery_order,:warehouse).where{
         (
           ( code =~ livesearch)  | 
           ( nomor_surat =~ livesearch)  | 
           ( delivery_order.nomor_surat =~ livesearch)  | 
           ( delivery_order.sales_order.contact.name =~ livesearch) | 
           ( warehouse.name =~  livesearch) 
         )
       }.count
 

     else
       @objects = TemporaryDeliveryOrder.active_objects.joins(:delivery_order,:warehouse).page(params[:page]).per(params[:limit]).order("id DESC")
       @total = TemporaryDeliveryOrder.active_objects.count
     end
     
     
     
     
  end

  def create
    
    params[:temporary_delivery_order][:delivery_date] =  parse_date( params[:temporary_delivery_order][:delivery_date] )
    
    
    @object = TemporaryDeliveryOrder.create_object( params[:temporary_delivery_order])
 
    if @object.errors.size == 0 
      
      render :json => { :success => true, 
                        :temporary_delivery_orders => [
                          :id => @object.id, 
                          :code => @object.code ,
                          :nomor_surat => @object.nomor_surat , 
                          :warehouse_id => @object.warehouse_id , 
                          :contact_name => @object.delivery_order.sales_order.contact.name , 
                          :delivery_order_nomor_surat => @object.delivery_order.nomor_surat , 
                          :delivery_date => format_date_friendly(@object.delivery_date)  ,
                          :is_confirmed => @object.is_confirmed,
                          :confirmed_at => format_date_friendly(@object.confirmed_at) 
                          ] , 
                        :total => TemporaryDeliveryOrder.active_objects.count }  
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
    @object  = TemporaryDeliveryOrder.find params[:id]
    @total = TemporaryDeliveryOrder.active_objects.count
  end

  def update
    params[:temporary_delivery_order][:delivery_date] =  parse_date( params[:temporary_delivery_order][:delivery_date] )
    params[:temporary_delivery_order][:confirmed_at] =  parse_date( params[:temporary_delivery_order][:confirmed_at] )
    
    @object = TemporaryDeliveryOrder.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_role?( :temporary_delivery_orders, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:temporary_delivery_order][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_role?( :temporary_delivery_orders, :unconfirm)
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
      @object.update_object(params[:temporary_delivery_order])
    end
    
     
    
    
    
    
    if @object.errors.size == 0 
      @total = TemporaryDeliveryOrder.active_objects.count
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
    @object = TemporaryDeliveryOrder.find(params[:id])
    @object.delete_object

    if   not @object.persisted? 
      render :json => { :success => true, :total => TemporaryDeliveryOrder.active_objects.count }  
    else
      render :json => { :success => false, :total => TemporaryDeliveryOrder.active_objects.count, 
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
      @objects = TemporaryDeliveryOrder.active_objects.joins(:delivery_order,:warehouse).where{  
        ( 
          ( code =~ query)  | 
           ( nomor_surat =~ query)  | 
           ( delivery_order.nomor_surat =~ query)  | 
           ( delivery_order.sales_order.contact.name =~  query) | 
           ( warehouse.name =~  query) 
         )
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = TemporaryDeliveryOrder.active_objects.joins(:delivery_order,:warehouse).where{  
        ( 
           ( code =~ query)  | 
           ( nomor_surat =~ query)  | 
           ( delivery_order.nomor_surat =~ query)  | 
           ( delivery_order.sales_order.contact.name =~  query) | 
           ( warehouse.name =~  query) 
         )
      }.count 
    else
      @objects = TemporaryDeliveryOrder.active_objects.joins(:delivery_order,:warehouse).where{ 
          (id.eq selected_id)   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = TemporaryDeliveryOrder.where{ 
          (id.eq selected_id)  
      }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
