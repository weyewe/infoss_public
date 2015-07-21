class Api::RollerIdentificationFormsController < Api::BaseApiController
  
  def index
     
     
     if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       @objects = RollerIdentificationForm.active_objects.joins(:contact,:warehouse).where{
         (
           ( code =~ livesearch)  | 
           ( nomor_disasembly =~ livesearch)  | 
           ( contact.name =~  livesearch) | 
           ( warehouse.name =~  livesearch) 
         )

       }.page(params[:page]).per(params[:limit]).order("id DESC")

       @total = RollerIdentificationForm.active_objects.joins(:contact,:warehouse).where{
         (
           ( code =~ livesearch)  | 
           ( nomor_disasembly =~ livesearch)  | 
           ( contact.name =~  livesearch) | 
           ( warehouse.name =~  livesearch) 
         )
       }.count
 

     else
       @objects = RollerIdentificationForm.active_objects.joins(:contact,:warehouse).page(params[:page]).per(params[:limit]).order("id DESC")
       @total = RollerIdentificationForm.active_objects.count
     end
     
     
     
     
  end

  def create
    
    params[:roller_identification_form][:incoming_roll] =  parse_date( params[:roller_identification_form][:incoming_roll] )
    params[:roller_identification_form][:identified_date] =  parse_date( params[:roller_identification_form][:identified_date] )
    
    
    @object = RollerIdentificationForm.create_object( params[:roller_identification_form])
 
    if @object.errors.size == 0 
      
      render :json => { :success => true, 
                        :roller_identification_forms => [
                          :id => @object.id, 
                          :code => @object.code ,
                          :warehouse_id => @object.warehouse_id , 
                          :warehouse_name => @object.warehouse.name , 
                          :incoming_roll => format_date_friendly(@object.incoming_roll)  ,
                          :identified_date => format_date_friendly(@object.identified_date)  ,
                          :is_in_house => @object.is_in_house,
                          :contact_id => @object.contact_id,
                          :contact_name => @object.contact.name,
                          :amount => @object.amount,
                          :is_confirmed => @object.is_confirmed,
                          :confirmed_at => format_date_friendly(@object.confirmed_at) 
                          ] , 
                        :total => RollerIdentificationForm.active_objects.count }  
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
    @object  = RollerIdentificationForm.find params[:id]
    @total = RollerIdentificationForm.active_objects.count
  end

  def update
    params[:roller_identification_form][:incoming_roll] =  parse_date( params[:roller_identification_form][:incoming_roll] )
    params[:roller_identification_form][:identified_date] =  parse_date( params[:roller_identification_form][:identified_date] )
    params[:roller_identification_form][:confirmed_at] =  parse_date( params[:roller_identification_form][:confirmed_at] )
    
    @object = RollerIdentificationForm.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_role?( :roller_identification_forms, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:roller_identification_form][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_role?( :roller_identification_forms, :unconfirm)
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
      @object.update_object(params[:roller_identification_form])
    end
    
     
    
    
    
    
    if @object.errors.size == 0 
      @total = RollerIdentificationForm.active_objects.count
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
    @object = RollerIdentificationForm.find(params[:id])
    @object.delete_object

    if   not @object.persisted? 
      render :json => { :success => true, :total => RollerIdentificationForm.active_objects.count }  
    else
      render :json => { :success => false, :total => RollerIdentificationForm.active_objects.count, 
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
      @objects = RollerIdentificationForm.active_objects.joins(:contact,:warehouse).where{  
        ( 
          ( code =~ query)  | 
          ( nomor_disasembly =~ query)  | 
          ( contact.name =~  query) | 
          ( warehouse.name =~  query) 
         )
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = RollerIdentificationForm.active_objects.joins(:contact,:warehouse).where{  
        ( 
          ( code =~ query)  | 
          ( nomor_disasembly =~ query)  | 
          ( contact.name =~  query) | 
          ( warehouse.name =~  query) 
         )
      }.count 
    else
      @objects = RollerIdentificationForm.active_objects.joins(:contact,:warehouse).where{ 
          (id.eq selected_id)   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = RollerIdentificationForm.active_objects.joins(:contact,:warehouse).where{ 
          (id.eq selected_id)  
      }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
