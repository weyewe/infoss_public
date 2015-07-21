class Api::SalesDownPaymentAllocationsController < Api::BaseApiController
  
  def index
     
     
     if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       @objects = SalesDownPaymentAllocation.active_objects.joins(:contact,:payable).where{
         (
           
          ( code =~ livesearch)  | 
           ( contact.name =~  livesearch) | 
           ( payable.source_code =~  livesearch) 
         )

       }.page(params[:page]).per(params[:limit]).order("id DESC")

       @total = SalesDownPaymentAllocation.active_objects.joins(:contact,:payable).where{
         (
            
           ( code =~ livesearch)  | 
           ( contact.name =~  livesearch) | 
           ( payable.source_code =~  livesearch) 
         )
       }.count
 

     else
       @objects = SalesDownPaymentAllocation.active_objects.joins(:contact,:payable).page(params[:page]).per(params[:limit]).order("id DESC")
       @total = SalesDownPaymentAllocation.active_objects.count
     end
     
     
     
     
  end

  def create
    
    params[:sales_down_payment_allocation][:allocation_date] =  parse_date( params[:sales_down_payment_allocation][:allocation_date] )
    
    
    @object = SalesDownPaymentAllocation.create_object( params[:sales_down_payment_allocation])
 
    if @object.errors.size == 0 
      
      render :json => { :success => true, 
                        :sales_down_payment_allocations => [
                          :id => @object.id, 
                          :contact_id => @object.contact_id, 
                          :contact_name => @object.contact.name, 
                          :payable_id => @object.payable_id, 
                          :payable_source_code => @object.payable.source_code, 
                          :code => @object.code, 
                          :allocation_date => format_date_friendly(@object.allocation_date) , 
                          :total_amount => @object.total_amount, 
                          :rate_to_idr => @object.rate_to_idr, 
                          :is_confirmed => @object.is_confirmed, 
                          :confirmed_at => format_date_friendly(@object.confirmed_at) 
                          ] , 
                        :total => SalesDownPaymentAllocation.active_objects.count }  
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
    @object  = SalesDownPaymentAllocation.find params[:id]
    render :json => { :success => true,   
                      :sales_down_payment_allocations => [
                          :id => @object.id, 
                          :contact_id => @object.contact_id, 
                          :contact_name => @object.contact.name, 
                          :payable_id => @object.payable_id, 
                          :payable_source_code => @object.payable.source_code, 
                          :code => @object.code, 
                          :allocation_date => format_date_friendly(@object.allocation_date) , 
                          :total_amount => @object.total_amount, 
                          :rate_to_idr => @object.rate_to_idr, 
                          :is_confirmed => @object.is_confirmed, 
                          :confirmed_at => format_date_friendly(@object.confirmed_at) 
                        
                        ],
                      :total => SalesDownPaymentAllocation.active_objects.count  }
  end

  def update
    params[:sales_down_payment_allocation][:allocation_date] =  parse_date( params[:sales_down_payment_allocation][:allocation_date] )
    params[:sales_down_payment_allocation][:confirmed_at] =  parse_date( params[:sales_down_payment_allocation][:confirmed_at] )
    
    @object = SalesDownPaymentAllocation.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_role?( :sales_down_payment_allocations, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:sales_down_payment_allocation][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_role?( :sales_down_payment_allocations, :unconfirm)
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
      @object.update_object(params[:sales_down_payment_allocation])
    end
    
     
    
    
    
    
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :sales_down_payment_allocations => [
                           :id => @object.id, 
                          :contact_id => @object.contact_id, 
                          :contact_name => @object.contact.name, 
                          :payable_id => @object.payable_id, 
                          :payable_source_code => @object.payable.source_code, 
                          :code => @object.code, 
                          :allocation_date => format_date_friendly(@object.allocation_date) , 
                          :total_amount => @object.total_amount, 
                          :rate_to_idr => @object.rate_to_idr, 
                          :is_confirmed => @object.is_confirmed, 
                          :confirmed_at => format_date_friendly(@object.confirmed_at) 
                          ],
                        :total => SalesDownPaymentAllocation.active_objects.count  } 
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
    @object = SalesDownPaymentAllocation.find(params[:id])
    @object.delete_object

    if   not @object.persisted? 
      render :json => { :success => true, :total => SalesDownPaymentAllocation.active_objects.count }  
    else
      render :json => { :success => false, :total => SalesDownPaymentAllocation.active_objects.count, 
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
      @objects = SalesDownPaymentAllocation.active_objects.joins(:contact,:payable).where{  
        ( 
           ( code =~ query)  | 
           ( contact.name =~  query) | 
           ( payable.source_code =~  query)   
         )
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = SalesDownPaymentAllocation.active_objects.joins(:contact,:payable).where{  
        ( 
            ( code =~ query)  | 
           ( contact.name =~  query) | 
           ( payable.source_code =~  query)   
         )
      }.count 
    else
      @objects = SalesDownPaymentAllocation.active_objects.joins(:contact,:payable).where{ 
          (id.eq selected_id)   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = SalesDownPaymentAllocation.active_objects.joins(:contact,:payable).where{ 
          (id.eq selected_id)  
      }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
