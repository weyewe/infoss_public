class Api::BlanketOrdersController < Api::BaseApiController
  
  def index
     
     
     if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       @objects = BlanketOrder.active_objects.joins(:contact,:warehouse).where{
         (
           ( code =~ livesearch)  | 
           ( production_no =~ livesearch)  | 
           ( contact.name =~  livesearch) | 
           ( warehouse.name =~  livesearch) | 
           ( notes =~  livesearch)
         )

       }.page(params[:page]).per(params[:limit]).order("id DESC")

       @total = BlanketOrder.active_objects.joins(:contact,:warehouse).where{
         (
           ( code =~ livesearch)  | 
           ( production_no =~ livesearch)  | 
           ( contact.name =~  livesearch) | 
           ( warehouse.name =~  livesearch) | 
           ( notes =~  livesearch)
         )
       }.count
 

     else
       @objects = BlanketOrder.active_objects.joins(:contact,:warehouse).page(params[:page]).per(params[:limit]).order("id DESC")
       @total = BlanketOrder.active_objects.count
     end
     
     
     
     
  end

  def create
    
    params[:blanket_order][:order_date] =  parse_date( params[:blanket_order][:order_date] )
    params[:blanket_order][:due_date] =  parse_date( params[:blanket_order][:due_date] )
    
    
    @object = BlanketOrder.create_object( params[:blanket_order])
 
    if @object.errors.size == 0 
      
      render :json => { :success => true, 
                        :blanket_orders => [
                         :id => @object.id, 
                            :code => @object.code ,
                            :order_date => format_date_friendly(@object.order_date)  ,
                            :production_no => @object.production_no,
                            :contact_id => @object.contact_id,
                            :contact_name => @object.contact.name,
                            :warehouse_id => @object.warehouse_id,
                            :warehouse_name => @object.warehouse.name,
                            :amount_final => @object.amount_final,
                            :amount_received => @object.amount_received,
                            :amount_rejected => @object.amount_rejected,
                            :has_due_date => @object.has_due_date,
                            :notes => @object.notes,
                            :due_date => format_date_friendly(@object.due_date),
                            :is_confirmed => @object.is_confirmed,
                            :confirmed_at => format_date_friendly(@object.confirmed_at),
                          ] , 
                        :total => BlanketOrder.active_objects.count }  
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
    @object  = BlanketOrder.find params[:id]
    @total = BlanketOrder.active_objects.count
  end

  def update
    params[:blanket_order][:order_date] =  parse_date( params[:blanket_order][:order_date] )
    params[:blanket_order][:due_date] =  parse_date( params[:blanket_order][:due_date] )
    params[:blanket_order][:confirmed_at] =  parse_date( params[:blanket_order][:confirmed_at] )
    
    @object = BlanketOrder.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_role?( :blanket_orders, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:blanket_order][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_role?( :blanket_orders, :unconfirm)
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
      @object.update_object(params[:blanket_order])
    end
    
     
    
    
    
    
    if @object.errors.size == 0 
      @total = BlanketOrder.active_objects.count
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
    @object = BlanketOrder.find(params[:id])
    @object.delete_object

    if   not @object.persisted? 
      render :json => { :success => true, :total => BlanketOrder.active_objects.count }  
    else
      render :json => { :success => false, :total => BlanketOrder.active_objects.count, 
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
      @objects = BlanketOrder.active_objects.joins(:contact,:warehouse).where{  
        ( 
            ( code =~ query)  | 
            ( production_no =~ query)  | 
            ( contact.name =~  query) | 
            ( warehouse.name =~  query) | 
            ( notes =~  query)
         )
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = BlanketOrder.active_objects.joins(:contact,:warehouse).where{  
        ( 
           ( code =~ query)  | 
           ( production_no =~ query)  | 
           ( contact.name =~  query) | 
           ( warehouse.name =~  query) | 
           ( notes =~  query)
         )
      }.count 
    else
      @objects = BlanketOrder.where{ 
          (id.eq selected_id)   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = BlanketOrder.where{ 
          (id.eq selected_id)  
      }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
