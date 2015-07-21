class Api::SalesInvoicesController < Api::BaseApiController
  
  def index
     
     
    # if params[:livesearch].present? 
    #   livesearch = "%#{params[:livesearch]}%"
    #   @objects = SalesInvoice.active_objects.joins(:delivery_order =>[:sales_order =>[:contact,:exchange]]).where{
    #     (
    #       ( description =~  livesearch ) | 
    #       ( code =~ livesearch)  | 
    #       ( nomor_surat =~ livesearch)  | 
    #       ( delivery_order.code =~  livesearch) |
    #       ( delivery_order.nomor_surat =~  livesearch)
    #     )


    #   }.page(params[:page]).per(params[:limit]).order("id DESC")

    #   @total = SalesInvoice.active_objects.joins(:delivery_order =>[:sales_order =>[:contact,:exchange]]).where{
    #     (
    #       ( description =~  livesearch ) | 
    #       ( code =~ livesearch)  | 
    #       ( nomor_surat =~ livesearch)  | 
    #       ( delivery_order.code =~  livesearch) |
    #       ( delivery_order.nomor_surat =~  livesearch)
    #     )

    #   }.count
 

    # else
    #   @objects = SalesInvoice.active_objects.joins(:delivery_order =>[:sales_order =>[:contact,:exchange]]).page(params[:page]).per(params[:limit]).order("id DESC")
    #   @total = SalesInvoice.active_objects.count
    # end
     
     
    # "livesearch"=>"", "is_confirmed"=>"on", "start_confirmation"=>"2015-07-01", "end_confirmation"=>"2015-07-09", "start_invoice_date"=>"2015-07-01", "end_invoice_date"=>"2015-07-09", "delivery_order_id"=>"2",
     
    query =   SalesInvoice.active_objects.joins(:delivery_order =>[:sales_order =>[:contact,:exchange]])
    # puts "The query : #{query}"
    # puts "initial query total: #{query.count}"
    
    if params[:livesearch].present?
      
      # livesearch = params[:livesearch]
      livesearch = "%#{params[:livesearch]}%"
      query = query.where{
         (
           ( description =~  livesearch ) | 
           ( code =~ livesearch)  | 
           ( nomor_surat =~ livesearch)  | 
           ( delivery_order.code =~  livesearch) |
           ( delivery_order.nomor_surat =~  livesearch)
         )

       }
    end
    
    # puts "after livesearch query total: #{query.count}" 
    start_confirmation =  parse_date( params[:start_confirmation] )
    end_confirmation =  parse_date( params[:end_confirmation] )
    start_invoice_date =  parse_date( params[:start_invoice_date] )
    end_invoice_date =  parse_date( params[:end_invoice_date] )
    
     
    
    if params[:is_confirmed].present?
      query = query.where(:is_confirmed => true ) 
      if  start_confirmation.present?
        query = query.where{ confirmed_at.gte start_confirmation }
      end
      
      if end_confirmation.present?
        query = query.where{ confirmed_at.lt  end_confirmation }
      end
    end
  
    if start_invoice_date.present?
      query = query.where{ invoice_date.gte start_invoice_date}
    end
    
    if end_invoice_date.present?
      query = query.where{ invoice_date.lt end_invoice_date}
    end
    
    object = DeliveryOrder.find_by_id params[:delivery_order_id]
    if not object.nil? 
      query = query.where(:delivery_order_id => object.id )
    end
    
   
    
    @objects = query.page(params[:page]).per(params[:limit]).order("id DESC")
    @total = query.count 
  end

  def create
    
    params[:sales_invoice][:invoice_date] =  parse_date( params[:sales_invoice][:invoice_date] )
    
    
    @object = SalesInvoice.create_object( params[:sales_invoice])
 
    if @object.errors.size == 0 
      
      render :json => { :success => true, 
                        :sales_invoices => [
                          :id => @object.id, 
                          :code => @object.code ,
                          :description => @object.description ,
                          :nomor_surat => @object.nomor_surat ,
                          :invoice_date => format_date_friendly(@object.invoice_date)  ,
                          :due_date => format_date_friendly(@object.due_date)  ,
                          :is_confirmed => @object.is_confirmed,
                          :confirmed_at => format_date_friendly(@object.confirmed_at) 
                          ] , 
                        :total => SalesInvoice.active_objects.count }  
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
    @object  = SalesInvoice.find params[:id]
    @total = SalesInvoice.active_objects.count
  end

  def update
    params[:sales_invoice][:invoice_date] =  parse_date( params[:sales_invoice][:invoice_date] )
    params[:sales_invoice][:confirmed_at] =  parse_date( params[:sales_invoice][:confirmed_at] )
    
    @object = SalesInvoice.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_role?( :sales_invoices, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:sales_invoice][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_role?( :sales_invoices, :unconfirm)
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
      @object.update_object(params[:sales_invoice])
    end
    
     
    
    
    
    
    if @object.errors.size == 0 
      @total = SalesInvoice.active_objects.count
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
    @object = SalesInvoice.find(params[:id])
    @object.delete_object

    if   not @object.persisted? 
      render :json => { :success => true, :total => SalesInvoice.active_objects.count }  
    else
      render :json => { :success => false, :total => SalesInvoice.active_objects.count, 
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
      @objects = SalesInvoice.where{  
        ( 
           ( code =~ query )  
         )
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = SalesInvoice.where{  
        ( 
           ( code =~ query )  
         )
      }.count 
    else
      @objects = SalesInvoice.where{ 
          (id.eq selected_id)   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = SalesInvoice.where{ 
          (id.eq selected_id)  
      }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
