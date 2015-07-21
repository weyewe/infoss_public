class Api::VirtualOrderClearancesController < Api::BaseApiController
  
  def index
     
     
     if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       @objects = VirtualOrderClearance.active_objects.joins(:virtual_delivery_order).where{
         (
           ( code =~ livesearch)  | 
           ( virtual_delivery_order.code =~ livesearch)   
         )

       }.page(params[:page]).per(params[:limit]).order("id DESC")

       @total = VirtualOrderClearance.active_objects.joins(:virtual_delivery_order).where{
         (
           ( code =~ livesearch)  | 
           ( virtual_delivery_order.code =~ livesearch) 
         )
       }.count
 

     else
       @objects = VirtualOrderClearance.active_objects.joins(:virtual_delivery_order).page(params[:page]).per(params[:limit]).order("id DESC")
       @total = VirtualOrderClearance.active_objects.count
     end
     
     
     
     
  end

  def create
    
    params[:virtual_order_clearance][:clearance_date] =  parse_date( params[:virtual_order_clearance][:clearance_date] )
    
    
    @object = VirtualOrderClearance.create_object( params[:virtual_order_clearance])
 
    if @object.errors.size == 0 
      
      render :json => { :success => true, 
                        :virtual_order_clearances => [
                          :id => @object.id, 
                          :code => @object.code ,
                          :virtual_delivery_order_id => @object.virtual_delivery_order_id , 
                          :total_waste_cogs => @object.total_waste_cogs , 
                          :clearance_date => format_date_friendly(@object.clearance_date)  ,
                          :is_confirmed => @object.is_confirmed,
                          :confirmed_at => format_date_friendly(@object.confirmed_at) 
                          ] , 
                        :total => VirtualOrderClearance.active_objects.count }  
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
    @object  = VirtualOrderClearance.find params[:id]
    @total = VirtualOrderClearance.active_objects.count
  end

  def update
    params[:virtual_order_clearance][:clearance_date] =  parse_date( params[:virtual_order_clearance][:clearance_date] )
    params[:virtual_order_clearance][:confirmed_at] =  parse_date( params[:virtual_order_clearance][:confirmed_at] )
    
    @object = VirtualOrderClearance.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_role?( :virtual_order_clearances, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:virtual_order_clearance][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_role?( :virtual_order_clearances, :unconfirm)
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
      @object.update_object(params[:virtual_order_clearance])
    end
    
     
    
    
    
    
    if @object.errors.size == 0  
      @total = VirtualOrderClearance.active_objects.count
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
    @object = VirtualOrderClearance.find(params[:id])
    @object.delete_object

    if   not @object.persisted? 
      render :json => { :success => true, :total => VirtualOrderClearance.active_objects.count }  
    else
      render :json => { :success => false, :total => VirtualOrderClearance.active_objects.count, 
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
      @objects = VirtualOrderClearance.active_objects.joins(:virtual_delivery_order).where{  
        ( 
           ( code =~ livesearch)  | 
           ( virtual_delivery_order.code =~ livesearch)   
         )
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = VirtualOrderClearance.active_objects.joins(:virtual_delivery_order).where{  
        ( 
           ( code =~ livesearch)  | 
           ( virtual_delivery_order.code =~ livesearch)   
         )
      }.count 
    else
      @objects = VirtualOrderClearance.active_objects.joins(:virtual_delivery_order).where{ 
          (id.eq selected_id)   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = VirtualOrderClearance.active_objects.joins(:virtual_delivery_order).where{ 
          (id.eq selected_id)  
      }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
