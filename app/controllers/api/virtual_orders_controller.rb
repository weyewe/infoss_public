class Api::VirtualOrdersController < Api::BaseApiController
  
  def index
     
     
     if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       @objects = VirtualOrder.active_objects.joins(:contact,:employee,:exchange).where{
         (
           
           ( code =~ livesearch)  | 
           ( nomor_surat =~ livesearch)  | 
           ( contact.name =~  livesearch) | 
           ( employee.name =~  livesearch) | 
           ( exchange.name =~  livesearch)
         )

       }.page(params[:page]).per(params[:limit]).order("id DESC")

       @total = VirtualOrder.active_objects.joins(:contact,:employee,:exchange).where{
         (
            
           ( code =~ livesearch)  | 
           ( nomor_surat =~ livesearch)  | 
           ( contact.name =~  livesearch) | 
           ( employee.name =~  livesearch) | 
           ( exchange.name =~  livesearch)
         )
       }.count
 

     else
       @objects = VirtualOrder.active_objects.joins(:contact,:employee,:exchange).page(params[:page]).per(params[:limit]).order("id DESC")
       @total = VirtualOrder.active_objects.count
     end
     
     
     
     
  end

  def create
    
    params[:virtual_order][:order_date] =  parse_date( params[:virtual_order][:order_date] )
    
    
    @object = VirtualOrder.create_object( params[:virtual_order])
 
    if @object.errors.size == 0 
      
      render :json => { :success => true, 
                        :virtual_orders => [
                          :id => @object.id, 
                          :code => @object.code ,
                          :exchange_id => @object.exchange_id ,
                          :contact_id => @object.contact_id ,
                          :contact_name => @object.contact.name ,
                          :exchange_name => @object.exchange.name ,
                          :employee_id => @object.employee_id ,
                          :employee_name => @object.employee.name ,
                          :nomor_surat => @object.nomor_surat , 
                          :order_date => format_date_friendly(@object.order_date)  ,
                          :is_confirmed => @object.is_confirmed,
                          :confirmed_at => format_date_friendly(@object.confirmed_at) 
                          ] , 
                        :total => VirtualOrder.active_objects.count }  
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
    @object  = VirtualOrder.find params[:id]
    @total = VirtualOrder.active_objects.count
  end

  def update
    params[:virtual_order][:order_date] =  parse_date( params[:virtual_order][:order_date] )
    params[:virtual_order][:confirmed_at] =  parse_date( params[:virtual_order][:confirmed_at] )
    
    @object = VirtualOrder.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_role?( :virtual_orders, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:virtual_order][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_role?( :virtual_orders, :unconfirm)
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
      @object.update_object(params[:virtual_order])
    end
    
     
    
    
    
    
    if @object.errors.size == 0 
      @total = VirtualOrder.active_objects.count
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
    @object = VirtualOrder.find(params[:id])
    @object.delete_object

    if   not @object.persisted? 
      render :json => { :success => true, :total => VirtualOrder.active_objects.count }  
    else
      render :json => { :success => false, :total => VirtualOrder.active_objects.count, 
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
      @objects = VirtualOrder.active_objects.joins(:contact,:employee,:exchange).where{  
        ( 
           ( code =~ query)  | 
           ( nomor_surat =~ query)  | 
           ( contact.name =~  query) | 
           ( employee.name =~  query) | 
           ( exchange.name =~  query)
        )
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = VirtualOrder.active_objects.joins(:contact,:employee,:exchange).where{  
        ( 
           ( code =~ query)  | 
           ( nomor_surat =~ query)  | 
           ( contact.name =~  query) | 
           ( employee.name =~  query) | 
           ( exchange.name =~  query)
         )
      }.count 
    else
      @objects = VirtualOrder.active_objects.joins(:contact,:employee,:exchange).where{ 
          (id.eq selected_id)   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = VirtualOrder.where{ 
          (id.eq selected_id)  
      }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
