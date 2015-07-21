class Api::SalesOrdersController < Api::BaseApiController
  
  def index
    
    # puts "\n"
    puts ">>>>>>>>>>>>>>\n "*5
    puts "The action : #{params[:action]}"
    puts "the controller: #{params[:controller]}"
    
#     The action : index
# the controller: api/sales_orders
    
    # build query
    query =   SalesOrder.active_objects.joins(:contact,:employee,:exchange)
    # puts "The query : #{query}"
    # puts "initial query total: #{query.count}"
    
    if params[:livesearch].present?
      
      # livesearch = params[:livesearch]
      livesearch = "%#{params[:livesearch]}%"
      query = query.where{
         (
           
           ( code =~ livesearch)  | 
           ( nomor_surat =~ livesearch)  | 
           ( contact.name =~  livesearch) | 
           ( employee.name =~  livesearch) | 
           ( exchange.name =~  livesearch)
         )

       }
    end
    
    # puts "after livesearch query total: #{query.count}" 
    start_confirmation =  parse_date( params[:start_confirmation] )
    end_confirmation =  parse_date( params[:end_confirmation] )
    start_sales_date =  parse_date( params[:start_sales_date] )
    end_sales_date =  parse_date( params[:end_sales_date] )
    
    
    if params[:is_confirmed].present?
      query = query.where(:is_confirmed => true ) 
      if start_confirmation.present?
        query = query.where{ confirmed_at.gte start_confirmation}
      end
      
      if end_confirmation.present?
        query = query.where{ confirmed_at.lt  end_confirmation}
      end
    end
  
    if start_sales_date.present?
      query = query.where{ sales_date.gte start_sales_date}
    end
    
    if end_sales_date.present?
      query = query.where{ sales_date.lt  end_sales_date}
    end
    
    object = Contact.find_by_id params[:contact_id]
    if not object.nil? 
      query = query.where(:contact_id => object.id )
    end
    
    object = Exchange.find_by_id params[:exchange_id]
    if not object.nil? 
      query = query.where(:exchange_id => object.id )
    end
    
    object = Employee.find_by_id params[:employee_id]
    if not object.nil? 
      query = query.where(:employee_id => object.id )
    end
    
    @objects = query.page(params[:page]).per(params[:limit]).order("id DESC")
    @total = query.count 
    
    
    # puts ">>>>>>>>>>>>\n\n total: #{@total}"
    # puts "The livesearch: #{params[:livesearch]}"
    # puts "@objects: #{@objects}"
    
    
     
     
    # if params[:livesearch].present? 
    #   livesearch = "%#{params[:livesearch]}%"
    #   @objects = SalesOrder.active_objects.joins(:contact,:employee,:exchange).where{
    #     (
           
    #       ( code =~ livesearch)  | 
    #       ( nomor_surat =~ livesearch)  | 
    #       ( contact.name =~  livesearch) | 
    #       ( employee.name =~  livesearch) | 
    #       ( exchange.name =~  livesearch)
    #     )

    #   }.page(params[:page]).per(params[:limit]).order("id DESC")

    #   @total = SalesOrder.active_objects.joins(:contact,:employee,:exchange).where{
    #     (
            
    #       ( code =~ livesearch)  | 
    #       ( nomor_surat =~ livesearch)  | 
    #       ( contact.name =~  livesearch) | 
    #       ( employee.name =~  livesearch) | 
    #       ( exchange.name =~  livesearch)
    #     )
    #   }.count
 

    # else
    #   @objects = SalesOrder.active_objects.joins(:contact,:employee,:exchange).page(params[:page]).per(params[:limit]).order("id DESC")
    #   @total = SalesOrder.active_objects.count
    # end
     
     
     
     
  end

  def create
    
    params[:sales_order][:sales_date] =  parse_date( params[:sales_order][:sales_date] )
    
    
    @object = SalesOrder.create_object( params[:sales_order])
 
    if @object.errors.size == 0 
      
      render :json => { :success => true, 
                        :sales_orders => [
                          :id => @object.id, 
                          :code => @object.code ,
                          :nomor_surat => @object.nomor_surat , 
                          :sales_date => format_date_friendly(@object.sales_date)  ,
                          :is_confirmed => @object.is_confirmed,
                          :confirmed_at => format_date_friendly(@object.confirmed_at) 
                          ] , 
                        :total => SalesOrder.active_objects.count }  
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
    @object  = SalesOrder.find params[:id]
    @total = SalesOrder.active_objects.count 
 
  end

  def update
    params[:sales_order][:sales_date] =  parse_date( params[:sales_order][:sales_date] )
    params[:sales_order][:confirmed_at] =  parse_date( params[:sales_order][:confirmed_at] )
    
    @object = SalesOrder.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_role?( :sales_orders, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:sales_order][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_role?( :sales_orders, :unconfirm)
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
      @object.update_object(params[:sales_order])
    end
    
     
    
    
    
    
    if @object.errors.size == 0 
      @total = SalesOrder.active_objects.count 
 
    else
      
      msg = {
        :success => false, 
        :message => {
          :errors => extjs_error_format( @object.errors )  
        }
      }
      
      render :json => msg
      return 
      return 
    end
  end
  
   

  def destroy
    @object = SalesOrder.find(params[:id])
    @object.delete_object

    if   not @object.persisted? 
      render :json => { :success => true, :total => SalesOrder.active_objects.count }  
    else
      render :json => { :success => false, :total => SalesOrder.active_objects.count, 
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
      @objects = SalesOrder.where{  
        ( 
           ( code =~ query )  
         )
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = SalesOrder.where{  
        ( 
           ( code =~ query )  
         )
      }.count 
    else
      @objects = SalesOrder.where{ 
          (id.eq selected_id)   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = SalesOrder.where{ 
          (id.eq selected_id)  
      }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
