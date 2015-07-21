class Api::PurchaseDownPaymentAllocationsController < Api::BaseApiController
  
  def index
     
     
     if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       @objects = PurchaseDownPaymentAllocation.active_objects.joins(:contact,:receivable).where{
         (
           
           ( code =~ livesearch)  | 
           ( contact.name =~  livesearch) | 
           ( receivable.source_code =~  livesearch) 
         )

       }.page(params[:page]).per(params[:limit]).order("id DESC")

       @total = PurchaseDownPaymentAllocation.active_objects.joins(:contact,:receivable).where{
         (
            
           ( code =~ livesearch)  | 
           ( contact.name =~  livesearch) | 
           ( receivable.source_code =~  livesearch) 
         )
       }.count
 

     else
       @objects = PurchaseDownPaymentAllocation.active_objects.joins(:contact,:receivable).page(params[:page]).per(params[:limit]).order("id DESC")
       @total = PurchaseDownPaymentAllocation.active_objects.count
     end
     
     
     
     
  end

  def create
    
    params[:purchase_down_payment_allocation][:allocation_date] =  parse_date( params[:purchase_down_payment_allocation][:allocation_date] )
    
    
    @object = PurchaseDownPaymentAllocation.create_object( params[:purchase_down_payment_allocation])
 
    if @object.errors.size == 0 
      
      render :json => { :success => true, 
                        :purchase_down_payment_allocations => [
                          :id => @object.id, 
                          :contact_id => @object.contact_id, 
                          :contact_name => @object.contact.name, 
                          :receivable_id => @object.receivable_id, 
                          :receivable_source_code => @object.receivable.source_code, 
                          :code => @object.code, 
                          :allocation_date => format_date_friendly(@object.allocation_date) , 
                          :total_amount => @object.total_amount, 
                          :rate_to_idr => @object.rate_to_idr, 
                          :is_confirmed => @object.is_confirmed, 
                          :confirmed_at => format_date_friendly(@object.confirmed_at) 
                          ] , 
                        :total => PurchaseDownPaymentAllocation.active_objects.count }  
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
    @object  = PurchaseDownPaymentAllocation.find params[:id]
    render :json => { :success => true,   
                      :purchase_down_payment_allocations => [
                          :id => @object.id, 
                          :contact_id => @object.contact_id, 
                          :contact_name => @object.contact.name, 
                          :receivable_id => @object.receivable_id, 
                          :receivable_source_code => @object.receivable.source_code, 
                          :code => @object.code, 
                          :allocation_date => format_date_friendly(@object.allocation_date) , 
                          :total_amount => @object.total_amount, 
                          :rate_to_idr => @object.rate_to_idr, 
                          :is_confirmed => @object.is_confirmed, 
                          :confirmed_at => format_date_friendly(@object.confirmed_at) 
                        
                        ],
                      :total => PurchaseDownPaymentAllocation.active_objects.count  }
  end

  def update
    params[:purchase_down_payment_allocation][:allocation_date] =  parse_date( params[:purchase_down_payment_allocation][:allocation_date] )
    params[:purchase_down_payment_allocation][:confirmed_at] =  parse_date( params[:purchase_down_payment_allocation][:confirmed_at] )
    
    @object = PurchaseDownPaymentAllocation.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_role?( :purchase_down_payment_allocations, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:purchase_down_payment_allocation][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_role?( :purchase_down_payment_allocations, :unconfirm)
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
      @object.update_object(params[:purchase_down_payment_allocation])
    end
    
     
    
    
    
    
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :purchase_down_payment_allocations => [
                           :id => @object.id, 
                            :contact_id => @object.contact_id, 
                            :contact_name => @object.contact.name, 
                            :receivable_id => @object.receivable_id, 
                            :receivable_source_code => @object.receivable.source_code, 
                            :code => @object.code, 
                            :allocation_date => format_date_friendly(@object.allocation_date) , 
                            :total_amount => @object.total_amount, 
                            :rate_to_idr => @object.rate_to_idr, 
                            :is_confirmed => @object.is_confirmed, 
                            :confirmed_at => format_date_friendly(@object.confirmed_at) 
                          ],
                        :total => PurchaseDownPaymentAllocation.active_objects.count  } 
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
    @object = PurchaseDownPaymentAllocation.find(params[:id])
    @object.delete_object

    if   not @object.persisted? 
      render :json => { :success => true, :total => PurchaseDownPaymentAllocation.active_objects.count }  
    else
      render :json => { :success => false, :total => PurchaseDownPaymentAllocation.active_objects.count, 
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
      @objects = PurchaseDownPaymentAllocation.active_objects.joins(:contact,:receivable).where{  
        ( 
           ( code =~ query )  |
           ( contact.name =~  query) | 
           ( receivable.source_code =~  query) 
         )
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = PurchaseDownPaymentAllocation.active_objects.joins(:contact,:receivable).where{  
        ( 
           ( code =~ query )  |
           ( contact.name =~  query) | 
           ( receivable.source_code =~  query)  
         )
      }.count 
    else
      @objects = PurchaseDownPaymentAllocation.active_objects.joins(:contact,:receivable).where{ 
          (id.eq selected_id)   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = PurchaseDownPaymentAllocation.active_objects.joins(:contact,:receivable).where{ 
          (id.eq selected_id)  
      }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
