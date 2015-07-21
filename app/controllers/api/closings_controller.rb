class Api::ClosingsController < Api::BaseApiController
  
  def index
     
     
     if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       @objects = Closing.active_objects.where{
         (
           ( period =~ livesearch)  | 
           ( year_period =~ livesearch) 
         )

       }.page(params[:page]).per(params[:limit]).order("id DESC")

       @total = Closing.active_objects.where{
         (
           ( period =~ livesearch)  | 
           ( year_period =~ livesearch) 
         )
       }.count
 

     else
       @objects = Closing.active_objects.page(params[:page]).per(params[:limit]).order("id DESC")
       @total = Closing.active_objects.count
     end
     
     
     
     
  end

  def create
    
    # params[:closing][:transaction_datetime] =  parse_date( params[:closing][:transaction_datetime] )
    
    
    @object = Closing.create_object( params[:closing])
 
    if @object.errors.size == 0 
      
      render :json => { :success => true, 
                        :closings => [
                          :id => @object.id, 
                          :period => @object.period ,
                          :year_period => @object.year_period , 
                          :beginning_period => format_date_friendly(@object.beginning_period)  ,
                          :end_date_period => format_date_friendly(@object.end_date_period)  ,
                          :is_year_closing => @object.is_year_closing ,
                          :is_closed => @object.is_closed , 
                          :closed_at => format_date_friendly(@object.closed_at) 
                          ] , 
                        :total => Closing.active_objects.count }  
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
    @object  = Closing.find params[:id]
    @total = Closing.active_objects.count
  end

  def update
    # params[:closing][:transaction_datetime] =  parse_date( params[:closing][:transaction_datetime] )
    params[:closing][:closed_at] =  parse_date( params[:closing][:closed_at] )
    
    @object = Closing.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_role?( :closings, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.close_object(:closed_at => params[:closing][:closed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_role?( :closings, :unconfirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.open_object
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
    else
      @object.update_object(params[:closing])
    end
    
     
    
    
    
    
    if @object.errors.size == 0 
      @total = Closing.active_objects.count
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
    @object = Closing.find(params[:id])
    @object.delete_object

    if   not @object.persisted? 
      render :json => { :success => true, :total => Closing.active_objects.count }  
    else
      render :json => { :success => false, :total => Closing.active_objects.count, 
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
      @objects = Closing.where{  
        ( 
           ( period =~ query)  | 
           ( year_period =~ query) 
         )
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = Closing.where{  
        ( 
           ( period =~ query)  | 
           ( year_period =~ query)  
         )
      }.count 
    else
      @objects = Closing.where{ 
          (id.eq selected_id)   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = Closing.where{ 
          (id.eq selected_id)  
      }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
