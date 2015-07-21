class Api::StockAdjustmentsController < Api::BaseApiController
  
  def index
     
     
     if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       @objects = StockAdjustment.active_objects.joins(:warehouse).where{
         (
           ( description =~  livesearch ) | 
           ( code =~ livesearch)  | 
           ( warehouse.name =~  livesearch)
         )
       }.page(params[:page]).per(params[:limit]).order("id DESC")

       @total = StockAdjustment.active_objects.joins(:warehouse).where{
         (
           ( description =~  livesearch ) | 
           ( code =~ livesearch)  | 
           ( warehouse.name =~  livesearch)
         )
       }.count
 

     else
       @objects = StockAdjustment.active_objects.joins(:warehouse).page(params[:page]).per(params[:limit]).order("id DESC")
       @total = StockAdjustment.active_objects.count
     end
     
     
     
     
  end

  def create
    
    params[:stock_adjustment][:adjustment_date] =  parse_date( params[:stock_adjustment][:adjustment_date] )
    
    
    @object = StockAdjustment.create_object( params[:stock_adjustment])
 
    if @object.errors.size == 0 

    
      render :json => { :success => true, 
                        :stock_adjustments => [
                          :id => @object.id, 
                          :warehouse_id => @object.warehouse_id, 
                          :code => @object.code ,
                          :description => @object.description , 
                          :adjustment_date => format_date_friendly(@object.adjustment_date)  ,
                          :is_confirmed => @object.is_confirmed,
                          :confirmed_at => format_date_friendly(@object.confirmed_at) 
                          ] , 
                        :total => StockAdjustment.active_objects.count }  
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
    @object  = StockAdjustment.find params[:id]
    @total = StockAdjustment.active_objects.count
  end

  def update
    params[:stock_adjustment][:adjustment_date] =  parse_date( params[:stock_adjustment][:adjustment_date] )
    params[:stock_adjustment][:confirmed_at] =  parse_date( params[:stock_adjustment][:confirmed_at] )
    
    @object = StockAdjustment.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_role?( :stock_adjustments, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:stock_adjustment][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_role?( :stock_adjustments, :unconfirm)
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
      @object.update_object(params[:stock_adjustment])
    end
    
     
    
    
    
    
    if @object.errors.size == 0 
      @total = StockAdjustment.active_objects.count
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
    @object = StockAdjustment.find(params[:id])
    @object.delete_object

    if   not @object.persisted? 
      render :json => { :success => true, :total => StockAdjustment.active_objects.count }  
    else
      render :json => { :success => false, :total => StockAdjustment.active_objects.count, 
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
      @objects = StockAdjustment.where{  
        ( 
           ( code =~ query )  
         )
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = StockAdjustment.where{  
        ( 
           ( code =~ query )  
         )
      }.count 
    else
      @objects = StockAdjustment.where{ 
          (id.eq selected_id)   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = StockAdjustment.where{ 
          (id.eq selected_id)  
      }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
