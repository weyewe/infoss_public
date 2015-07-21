class Api::RollerAccsController < Api::BaseApiController
  
  def index
     
     
     if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       @objects = RollerIdentificationFormDetail.active_objects.joins(:roller_identification_form, :core_builder,:roller_type,:machine).where{
         (
           ( machine.name =~  livesearch) | 
           ( roller_type.name =~  livesearch) | 
           ( core_builder.name =~  livesearch)
         )

       }.page(params[:page]).per(params[:limit]).order("id DESC")

       @total = RollerIdentificationFormDetail.active_objects.joins(:roller_identification_form, :core_builder,:roller_type,:machine).where{
         (
           ( machine.name =~  livesearch) | 
           ( roller_type.name =~  livesearch) | 
           ( core_builder.name =~  livesearch)
         )
       }.count
     else
       @objects = RollerIdentificationFormDetail.active_objects.joins(:roller_identification_form, :core_builder,:roller_type,:machine).page(params[:page]).per(params[:limit]).order("id DESC")
       @total = RollerIdentificationFormDetail.active_objects.count
     end
     
     
     
     
  end

  def create
    
    params[:roller_acc][:transaction_datetime] =  parse_date( params[:roller_acc][:transaction_datetime] )
    
    
    @object = RollerAcc.create_object( params[:roller_acc])
 
    if @object.errors.size == 0 
      
      render :json => { :success => true, 
                        :roller_accs => [
                          :id => @object.id, 
                          :code => @object.code ,
                          :nomor_surat => @object.nomor_surat , 
                          :sales_date => format_date_friendly(@object.sales_date)  ,
                          :is_confirmed => @object.is_confirmed,
                          :confirmed_at => format_date_friendly(@object.confirmed_at) 
                          ] , 
                        :total => RollerAcc.active_objects.count }  
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
    @object  = RollerIdentificationFormDetail.find params[:id]
    @total = RollerIdentificationFormDetail.active_objects.count
  end

  def update
    params[:roller_acc][:transaction_datetime] =  parse_date( params[:roller_acc][:transaction_datetime] )
    params[:roller_acc][:confirmed_at] =  parse_date( params[:roller_acc][:confirmed_at] )
    
    @object = RollerAcc.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_role?( :roller_accs, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:roller_acc][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_role?( :roller_accs, :unconfirm)
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
      @object.update_object(params[:roller_acc])
    end
    
     
    
    
    
    
    if @object.errors.size == 0 
      @total = RollerAcc.active_objects.count
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
    @object = RollerAcc.find(params[:id])
    @object.delete_object

    if   not @object.persisted? 
      render :json => { :success => true, :total => RollerAcc.active_objects.count }  
    else
      render :json => { :success => false, :total => RollerAcc.active_objects.count, 
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
      @objects = RollerIdentificationFormDetail.active_objects.joins(:roller_identification_form, :core_builder,:roller_type,:machine).where{  
        ( 
           ( machine.name =~  query) | 
           ( roller_type.name =~  query) | 
           ( core_builder.name =~  query) 
         )
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = RollerIdentificationFormDetail.active_objects.joins(:roller_identification_form, :core_builder,:roller_type,:machine).where{  
        ( 
           ( machine.name =~  query) | 
           ( roller_type.name =~  query) | 
           ( core_builder.name =~  query)
         )
      }.count 
    else
      @objects = RollerIdentificationFormDetail.active_objects.joins(:roller_identification_form, :core_builder,:roller_type,:machine).where{ 
          (id.eq selected_id)   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = RollerIdentificationFormDetail.active_objects.joins(:roller_identification_form, :core_builder,:roller_type,:machine).where{ 
          (id.eq selected_id)  
      }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
