class Api::HomeAssignmentsController < Api::BaseApiController
  
  def index
     
     
     if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       @objects = HomeAssignment.active_objects.where{
         (is_deleted.eq false ) & 
         (
           (description =~  livesearch ) | 
           ( code =~ livesearch)
         )

       }.page(params[:page]).per(params[:limit]).order("id DESC")

       @total = HomeAssignment.active_objects.where{
         (is_deleted.eq false ) & 
         (
           (description =~  livesearch ) | 
            ( code =~ livesearch)
         )
       }.count
 

     else
       @objects = HomeAssignment.active_objects.page(params[:page]).per(params[:limit]).order("id DESC")
       @total = HomeAssignment.active_objects.count
     end
     
     
     
     
  end

  def create
    
    params[:home_assignment][:transaction_datetime] =  parse_date( params[:home_assignment][:transaction_datetime] )
    
    
    @object = HomeAssignment.create_object( params[:home_assignment])
 
    if @object.errors.size == 0 
      
      render :json => { :success => true, 
                        :home_assignments => [
                          :id => @object.id, 
                          :code => @object.code ,
                          :description => @object.description ,
                          :transaction_datetime => format_date_friendly(@object.transaction_datetime)  ,
                          :is_confirmed => @object.is_confirmed,
                          :confirmed_at => format_date_friendly(@object.confirmed_at) 
                          ] , 
                        :total => HomeAssignment.active_objects.count }  
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
    @object  = HomeAssignment.find params[:id]
    render :json => { :success => true,   
                      :home_assignments => [
                          :id => @object.id, 
                          :code => @object.code ,
                          :description => @object.description ,
                          :transaction_datetime => format_date_friendly(@object.transaction_datetime)  ,
                          :is_confirmed => @object.is_confirmed,
                          :confirmed_at => format_date_friendly(@object.confirmed_at)
                        
                        ],
                      :total => HomeAssignment.active_objects.count  }
  end

  def update
    params[:home_assignment][:transaction_datetime] =  parse_date( params[:home_assignment][:transaction_datetime] )
    params[:home_assignment][:confirmed_at] =  parse_date( params[:home_assignment][:confirmed_at] )
    
    @object = HomeAssignment.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_role?( :home_assignments, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm(:confirmed_at => params[:home_assignment][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_role?( :home_assignments, :unconfirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.unconfirm
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
    else
      @object.update_object(params[:home_assignment])
    end
    
     
    
    
    
    
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :home_assignments => [
                            :id => @object.id,
                            :code => @object.code ,
                            :description => @object.description ,
                            :transaction_datetime => format_date_friendly(@object.transaction_datetime),
                            :is_confirmed => @object.is_confirmed,
                            :confirmed_at => format_date_friendly(@object.confirmed_at)
                          ],
                        :total => HomeAssignment.active_objects.count  } 
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
    @object = HomeAssignment.find(params[:id])
    @object.delete_object

    if (( not @object.persisted? )   or @object.is_deleted ) and @object.errors.size == 0
      render :json => { :success => true, :total => HomeAssignment.active_objects.count }  
    else
      render :json => { :success => false, :total => HomeAssignment.active_objects.count, 
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
      @objects = HomeAssignment.where{  (title =~ query)   & 
                                (is_deleted.eq false )
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
    else
      @objects = HomeAssignment.where{ (id.eq selected_id)  & 
                                (is_deleted.eq false )
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
    end
    
    
    render :json => { :records => @objects , :total => @objects.count, :success => true }
  end
end
