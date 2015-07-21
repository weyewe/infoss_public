class Api::PaymentRequestsController < Api::BaseApiController
  
  def index
     
     
     if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       @objects = PaymentRequest.active_objects.joins(:contact,:exchange).where{
         (
           ( code =~ livesearch)  | 
           ( description =~ livesearch)  | 
           ( no_bukti =~ livesearch)  | 
           ( contact.name =~  livesearch) 
         )

       }.page(params[:page]).per(params[:limit]).order("id DESC")

       @total = PaymentRequest.active_objects.joins(:contact,:exchange).where{
         (
           ( code =~ livesearch)  | 
           ( description =~ livesearch)  | 
           ( no_bukti =~ livesearch)  | 
           ( contact.name =~  livesearch) 
         )
       }.count
 

     else
       @objects = PaymentRequest.active_objects.joins(:contact,:exchange).page(params[:page]).per(params[:limit]).order("id DESC")
       @total = PaymentRequest.active_objects.count
     end
     
     
     
     
  end

  def create
    
    params[:payment_request][:request_date] =  parse_date( params[:payment_request][:request_date] )
    params[:payment_request][:due_date] =  parse_date( params[:payment_request][:due_date] )
    
    
    @object = PaymentRequest.create_object( params[:payment_request])
 
    if @object.errors.size == 0 
      
      render :json => { :success => true, 
                        :payment_requests => [
                          :id => @object.id, 
                          :code => @object.code ,
                          :account_id => @object.account_id ,
                          :no_bukti => @object.no_bukti , 
                          :description => @object.description , 
                          :amount => @object.amount , 
                          :contact_name => @object.contact.name,
                          :request_date => format_date_friendly(@object.request_date)  ,
                          :due_date => format_date_friendly(@object.due_date)  ,
                          :is_confirmed => @object.is_confirmed,
                          :confirmed_at => format_date_friendly(@object.confirmed_at) 
                          ] , 
                        :total => PaymentRequest.active_objects.count }  
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
    @object  = PaymentRequest.find params[:id]
    @total = PaymentRequest.active_objects.count
  end

  def update
    params[:payment_request][:transaction_datetime] =  parse_date( params[:payment_request][:transaction_datetime] )
    params[:payment_request][:confirmed_at] =  parse_date( params[:payment_request][:confirmed_at] )
    
    @object = PaymentRequest.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_role?( :payment_requests, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:payment_request][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_role?( :payment_requests, :unconfirm)
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
      @object.update_object(params[:payment_request])
    end
    
     
    
    
    
    
    if @object.errors.size == 0 
      @total = PaymentRequest.active_objects.count
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
    @object = PaymentRequest.find(params[:id])
    @object.delete_object

    if   not @object.persisted? 
      render :json => { :success => true, :total => PaymentRequest.active_objects.count }  
    else
      render :json => { :success => false, :total => PaymentRequest.active_objects.count, 
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
      @objects = PaymentRequest.where{  
        ( 
           ( code =~ query )  
         )
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = PaymentRequest.where{  
        ( 
           ( code =~ query )  
         )
      }.count 
    else
      @objects = PaymentRequest.where{ 
          (id.eq selected_id)   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = PaymentRequest.where{ 
          (id.eq selected_id)  
      }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
