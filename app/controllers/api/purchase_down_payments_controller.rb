class Api::PurchaseDownPaymentsController < Api::BaseApiController
  
  def index
     
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
        
        
        @objects = PurchaseDownPayment.active_objects.joins(:contact,:exchange,:payable,:receivable).where{
          (
            ( code =~  livesearch )  | 
            ( contact.name =~ livesearch ) | 
            ( exchange.name =~ livesearch ) 
          )

        }.page(params[:page]).per(params[:limit]).order("id DESC")

        @total = PurchaseDownPayment.active_objects.joins(:contact,:exchange,:payable,:receivable).where{
          (
            ( code =~  livesearch )  | 
            ( contact.name =~ livesearch ) | 
            ( exchange.name =~ livesearch ) 
          )
        }.count
   
    else
      puts "In this shite"
      @objects = PurchaseDownPayment.page(params[:page]).per(params[:limit]).order("id DESC")
      @total = PurchaseDownPayment.count 
    end
    
    
    # render :json => { :purchase_down_payments => @objects , :total => @total , :success => true }
  end

  def create
    @object = PurchaseDownPayment.create_object( params[:purchase_down_payment] )
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :purchase_down_payments => [@object] , 
                        :total => PurchaseDownPayment.active_objects.count  }  
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

  def update
    @object = PurchaseDownPayment.find(params[:id]) 
    
    if params[:confirm].present?  
      if not current_user.has_role?( :purchase_down_payments, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:purchase_down_payment][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_role?( :purchase_down_payments, :unconfirm)
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
    @object.update_object( params[:purchase_down_payment] )
  end
     
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :purchase_down_payments => [@object],
                        :total => PurchaseDownPayment.active_objects.count } 
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
  
  def show
    @object = PurchaseDownPayment.find_by_id params[:id]
    render :json => { :success => true, 
                      :purchase_down_payments => [@object] , 
                      :total => PurchaseDownPayment.count }
  end

  def destroy
    @object = PurchaseDownPayment.find(params[:id])
    
    begin
      ActiveRecord::Base.transaction do 
        @object.delete_object 
      end
    rescue ActiveRecord::ActiveRecordError  
    else
    end
    
    

    if not @object.persisted?  
      render :json => { :success => true, :total => PurchaseDownPayment.active_objects.count }  
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
  
  
  def search
    search_params = params[:query]
    selected_id = params[:selected_id]
    if params[:selected_id].nil?  or params[:selected_id].length == 0 
      selected_id = nil
    end
    
    query = "%#{search_params}%"
    # on PostGre SQL, it is ignoring lower case or upper case 
    
    if  selected_id.nil?
      @objects = PurchaseDownPayment.active_objects.joins(:contact,:exchange,:payable,:receivable).where{ 
            ( code =~  query )  | 
            ( contact.name =~ query ) | 
            ( exchange.name =~ query ) 
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = PurchaseDownPayment.active_objects.joins(:contact,:exchange,:payable,:receivable).where{ 
            ( code =~  query )  | 
            ( contact.name =~ query ) | 
            ( exchange.name =~ query ) 
        
                              }.count
    else
      @objects = PurchaseDownPayment.active_objects.joins(:contact,:exchange,:payable,:receivable).where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = PurchaseDownPayment.active_objects.joins(:contact,:exchange,:payable,:receivable)..where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
