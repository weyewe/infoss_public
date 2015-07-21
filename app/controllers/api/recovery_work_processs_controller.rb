class Api::RecoveryOrderDetailsController < Api::BaseApiController
  
  def index
     
     
     if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       @objects = RecoveryOrderDetail.active_objects.joins(:recovery_order,:roller_builder,:roller_identification_form_detail).where{
         (
           
           ( roller_builder.base_sku  =~ livesearch ) | 
          ( roller_builder.code  =~ livesearch )  
         )

       }.page(params[:page]).per(params[:limit]).order("id DESC")

       @total = RecoveryOrderDetail.active_objects.joins(:recovery_order,:roller_builder,:roller_identification_form_detail).where{
         (
           ( roller_builder.base_sku  =~ livesearch ) | 
            ( roller_builder.code  =~ livesearch ) 
         )
       }.count
 

     else
       @objects = RecoveryOrderDetail.active_objects.joins(:recovery_order,:roller_builder,:roller_identification_form_detail).page(params[:page]).per(params[:limit]).order("id DESC")
       @total = RecoveryOrderDetail.active_objects.count
     end
     
     
     
     
  end

  def create
    
    params[:recovery_work_process][:transaction_datetime] =  parse_date( params[:recovery_work_process][:transaction_datetime] )
    
    
    @object = RecoveryOrderDetail.create_object( params[:recovery_work_process])
 
    if @object.errors.size == 0 
      
      render :json => { :success => true, 
                        :recovery_work_processs => [
                          :id => @object.id, 
                          :recovery_order_id => @object.recovery_order_id, 
                          :roller_identification_form_detail_id => @object.roller_identification_form_detail_id, 
                          :roller_identification_form_detail_core_sku => @object.roller_identification_form_detail.core_builder.base_sku, 
                          :roller_identification_form_detail_core_name => @object.roller_identification_form_detail.core_builder.name, 
                          :roller_builder_id => @object.roller_builder_id, 
                          :roller_builder_sku => @object.roller_builder.base_sku, 
                          :roller_builder_name => @object.roller_builder.name, 
                          :total_cost => @object.total_cost, 
                          :compound_usage => @object.compound_usage, 
                          :core_type_case => @object.core_type_case, 
                          :core_type_case => @object.core_type_case, 
                          :is_disassembled => @object.is_disassembled, 
                          :is_stripped_and_glued => @object.is_stripped_and_glued, 
                          :is_wrapped => @object.is_wrapped, 
                          :is_vulcanized => @object.is_vulcanized, 
                          :is_faced_off => @object.is_faced_off, 
                          :is_conventional_grinded => @object.is_conventional_grinded, 
                          :is_cnc_grinded => @object.is_cnc_grinded, 
                          :is_polished_and_gc => @object.is_polished_and_gc, 
                          :is_packaged => @object.is_packaged, 
                          :is_rejected => @object.is_rejected, 
                          :rejected_date => format_date_friendly(@object.rejected_date), 
                          :is_finished => @object.is_finished, 
                          :finished_date => format_date_friendly(@object.finished_date), 
                          :accessories_cost => @object.accessories_cost, 
                          :core_cost => @object.core_cost, 
                          :compound_cost => @object.compound_cost, 
                          :compound_under_layer_id => @object.compound_under_layer_id, 
                          :compound_under_layer_name => @object.compound_under_layer.name, 
                          :compound_under_layer_usage => @object.compound_under_layer_usage, 
                          ] , 
                        :total => RecoveryOrderDetail.active_objects.count }  
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
    @object  = RecoveryOrderDetail.find params[:id] 
    @total = RecoveryOrderDetail.active_objects.count
  end

  def update
    params[:recovery_work_process][:finished_date] =  parse_date( params[:recovery_work_process][:finished_date] )
    params[:recovery_work_process][:rejected_date] =  parse_date( params[:recovery_work_process][:rejected_date] )
    
    @object = RecoveryOrderDetail.find(params[:id])
    
    if params[:finish].present?  
      if not current_user.has_role?( :recovery_work_processs, :finish)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.finish_object(:finished_date => params[:recovery_work_process][:finished_date] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
    elsif params[:reject].present?  
      if not current_user.has_role?( :recovery_work_processs, :reject)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.reject_object(:rejected_date => params[:recovery_work_process][:rejected_date] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
    elsif params[:unfinish].present?    
      
      if not current_user.has_role?( :recovery_work_processs, :unconfirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.unfinish_object
          
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
    
    elsif params[:unreject].present?    
      
      if not current_user.has_role?( :recovery_work_processs, :unreject)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.unreject_object
          
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
    else
      @object.process_object(params[:recovery_work_process])
    end
    
     
    
    
    
    
    if @object.errors.size == 0 
      @total = RecoveryOrderDetail.active_objects.count
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
    @object = RecoveryOrderDetail.find(params[:id])
    @object.delete_object

    if   not @object.persisted? 
      render :json => { :success => true, :total => RecoveryOrderDetail.active_objects.count }  
    else
      render :json => { :success => false, :total => RecoveryOrderDetail.active_objects.count, 
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
      @objects = RecoveryOrderDetail.active_objects.joins(:recovery_order,:roller_builder,:roller_identification_form_detail).where{  
        ( 
           ( roller_builder.base_sku  =~ query ) | 
            ( roller_builder.code  =~ query ) 
         )
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = RecoveryOrderDetail.active_objects.joins(:recovery_order,:roller_builder,:roller_identification_form_detail).where{  
        ( 
           ( roller_builder.base_sku  =~ query ) | 
            ( roller_builder.code  =~ query ) 
         )
      }.count 
    else
      @objects = RecoveryOrderDetail.active_objects.joins(:recovery_order,:roller_builder,:roller_identification_form_detail).where{ 
          (id.eq selected_id)   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = RecoveryOrderDetail.active_objects.joins(:recovery_order,:roller_builder,:roller_identification_form_detail).where{ 
          (id.eq selected_id)  
      }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
