class Api::DeliveryOrdersController < Api::BaseApiController
  
  def index
      # "livesearch"=>"", "is_confirmed"=>"on", "start_confirmation"=>"2015-07-01", "end_confirmation"=>"2015-07-04", "start_delivery_date"=>"2015-07-08", "end_delivery_date"=>"2015-07-11", "warehouse_id"=>"7", "sales_order_id"=>"8",
     
    # if params[:livesearch].present? 
    #   livesearch = "%#{params[:livesearch]}%"
    #   @objects = DeliveryOrder.active_objects.joins(:warehouse,:sales_order).where{
    #     (
    #       ( nomor_surat =~  livesearch ) | 
    #       ( code =~ livesearch)  | 
    #       ( warehouse.name =~  livesearch) |
    #       ( sales_order.code =~  livesearch) |
    #       ( sales_order.contact.name =~  livesearch) |
    #       ( sales_order.nomor_surat =~  livesearch)
    #     )
    #   }.page(params[:page]).per(params[:limit]).order("id DESC")

    #   @total = DeliveryOrder.active_objects.joins(:warehouse,:sales_order).where{
    #     (
    #       ( nomor_surat =~  livesearch ) | 
    #       ( code =~ livesearch)  | 
    #       ( warehouse.name =~  livesearch) |
    #       ( sales_order.code =~  livesearch) |
    #       ( sales_order.contact.name =~  livesearch) |
    #       ( sales_order.nomor_surat =~  livesearch)
    #     )
    #   }.count
 

    # else
    #   @objects = DeliveryOrder.active_objects.joins(:warehouse,:sales_order).page(params[:page]).per(params[:limit]).order("id DESC")
    #   @total = DeliveryOrder.active_objects.count
    # end
     
     
     
     
    query =   DeliveryOrder.active_objects.joins(:warehouse, :sales_order)
    # puts "The query : #{query}"
    # puts "initial query total: #{query.count}"
    
    if params[:livesearch].present?
      
      # livesearch = params[:livesearch]
      livesearch = "%#{params[:livesearch]}%"
      query = query.where{
         (
           ( nomor_surat =~  livesearch ) | 
           ( code =~ livesearch)  | 
           ( warehouse.name =~  livesearch) |
           ( sales_order.code =~  livesearch) |
           ( sales_order.contact.name =~  livesearch) |
           ( sales_order.nomor_surat =~  livesearch)
         )

       }
    end
    
    # puts "after livesearch query total: #{query.count}" 
    start_confirmation =  parse_date( params[:start_confirmation] )
    end_confirmation =  parse_date( params[:end_confirmation] )
    start_delivery_date =  parse_date( params[:start_delivery_date] )
    end_delivery_date =  parse_date( params[:end_delivery_date] )
    
    
    if params[:is_confirmed].present?
      query = query.where(:is_confirmed => true ) 
      if start_confirmation.present?
        query = query.where{ confirmed_at.gte start_confirmation}
      end
      
      if end_confirmation.present?
        query = query.where{ confirmed_at.lt  end_confirmation }
      end
    end
  
    if start_delivery_date.present?
      query = query.where{ delivery_date.gte start_delivery_date}
    end
    
    if end_delivery_date.present?
      query = query.where{ delivery_date.lt end_delivery_date}
    end
    
    object = Warehouse.find_by_id params[:warehouse_id]
    if not object.nil? 
      query = query.where(:warehouse_id => object.id )
    end
    
    object = SalesOrder.find_by_id params[:sales_order_id]
    if not object.nil? 
      query = query.where(:sales_order_id => object.id )
    end
     
    
    @objects = query.page(params[:page]).per(params[:limit]).order("id DESC")
    @total = query.count 
     
     
     
     
  end
  
  

	

  def create
    
    params[:delivery_order][:delivery_date] =  parse_date( params[:delivery_order][:delivery_date] )
    
    
    @object = DeliveryOrder.create_object( params[:delivery_order])
 
    if @object.errors.size == 0 
      
      render :json => { :success => true, 
                        :delivery_orders => [
                          :id => @object.id, 
                          :code => @object.code ,
                          :nomor_surat => @object.nomor_surat ,
                          :warehouse_id => @object.warehouse_id,
                          :warehouse_name => @object.warehouse.name, 
                          :sales_order_code => @object.sales_order.code,
                          :contact_name => @object.sales_order.contact.name,
                          :sales_order_id => @object.sales_order.id ,
                          :delivery_date => format_date_friendly(@object.delivery_date)  ,
                          :is_confirmed => @object.is_confirmed,
                          :confirmed_at => format_date_friendly(@object.confirmed_at) 
                          ] , 
                        :total => DeliveryOrder.active_objects.count }  
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
    @object  = DeliveryOrder.find params[:id]
    @total = DeliveryOrder.active_objects.count
  end

  def update
    params[:delivery_order][:delivery_date] =  parse_date( params[:delivery_order][:delivery_date] )
    params[:delivery_order][:confirmed_at] =  parse_date( params[:delivery_order][:confirmed_at] )
    
    @object = DeliveryOrder.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_role?( :delivery_orders, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:delivery_order][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_role?( :delivery_orders, :unconfirm)
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
      @object.update_object(params[:delivery_order])
    end
    
     
    
    
    
    
    if @object.errors.size == 0 
      @total = DeliveryOrder.active_objects.count
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
    @object = DeliveryOrder.find(params[:id])
    @object.delete_object

    if   not @object.persisted? 
      render :json => { :success => true, :total => DeliveryOrder.active_objects.count }  
    else
      render :json => { :success => false, :total => DeliveryOrder.active_objects.count, 
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
      @objects = DeliveryOrder.where{  
        ( 
           ( code =~ query )  
         )
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = DeliveryOrder.where{  
        ( 
           ( code =~ query )  
         )
      }.count 
    else
      @objects = DeliveryOrder.where{ 
          (id.eq selected_id)   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = DeliveryOrder.where{ 
          (id.eq selected_id)  
      }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
