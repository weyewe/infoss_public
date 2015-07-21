class Api::PurchaseOrdersController < Api::BaseApiController
  
  def index
     
     
     if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       @objects = PurchaseOrder.active_objects.joins(:contact,:exchange).where{
         (
           ( description =~  livesearch ) | 
           ( code =~ livesearch)  | 
           ( nomor_surat =~ livesearch)  | 
           ( contact.name =~  livesearch) | 
           ( exchange.name =~  livesearch)
         )

       }.page(params[:page]).per(params[:limit]).order("id DESC")

       @total = PurchaseOrder.active_objects.joins(:contact,:exchange).where{
         (
           ( description =~  livesearch ) | 
           ( code =~ livesearch)  | 
           ( nomor_surat =~ livesearch)  | 
           ( contact.name =~  livesearch) | 
           ( exchange.name =~  livesearch)
         )
       }.count
 

     else
       @objects = PurchaseOrder.active_objects.joins(:contact,:exchange).page(params[:page]).per(params[:limit]).order("id DESC")
       @total = PurchaseOrder.active_objects.count
     end
     
     
     
     
  end

  def create
    
    params[:purchase_order][:purchase_date] =  parse_date( params[:purchase_order][:purchase_date] )
    
    
    @object = PurchaseOrder.create_object( params[:purchase_order])
 
    if @object.errors.size == 0 
      
      render :json => { :success => true, 
                        :purchase_orders => [
                          :id => @object.id, 
                          :code => @object.code ,
                          :nomor_surat => @object.nomor_surat ,
                          :description => @object.description ,
                          :purchase_date => format_date_friendly(@object.purchase_date)  ,
                          :allow_edit_detail => @object.allow_edit_detail,
                          :is_confirmed => @object.is_confirmed,
                          :confirmed_at => format_date_friendly(@object.confirmed_at) 
                          ] , 
                        :total => PurchaseOrder.active_objects.count }  
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
    @object  = PurchaseOrder.find params[:id]
    @total = PurchaseOrder.active_objects.count
  end

  def update
    params[:purchase_order][:purchase_date] =  parse_date( params[:purchase_order][:purchase_date] )
    params[:purchase_order][:confirmed_at] =  parse_date( params[:purchase_order][:confirmed_at] )
    
    @object = PurchaseOrder.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_role?( :purchase_orders, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:purchase_order][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_role?( :purchase_orders, :unconfirm)
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
      @object.update_object(params[:purchase_order])
    end
    
     
    
    
    
    
    if @object.errors.size == 0 
      @total = PurchaseOrder.active_objects.count
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
    @object = PurchaseOrder.find(params[:id])
    @object.delete_object

    if   not @object.persisted? 
      render :json => { :success => true, :total => PurchaseOrder.active_objects.count }  
    else
      render :json => { :success => false, :total => PurchaseOrder.active_objects.count, 
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
      @objects = PurchaseOrder.where{  
        ( 
           ( code =~ query )  
         )
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = PurchaseOrder.where{  
        ( 
           ( code =~ query )  
         )
      }.count 
    else
      @objects = PurchaseOrder.where{ 
          (id.eq selected_id)   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = PurchaseOrder.where{ 
          (id.eq selected_id)  
      }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
