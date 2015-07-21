class Api::WarehouseMutationsController < Api::BaseApiController
  
  def index
     
     
     if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       @objects = WarehouseMutation.active_objects. where{
         (
           ( code =~ livesearch)
         )
       }.page(params[:page]).per(params[:limit]).order("id DESC")

       @total = WarehouseMutation.active_objects. where{
         (
           ( code =~ livesearch)
         )
       }.count
 

     else
       @objects = WarehouseMutation.active_objects.page(params[:page]).per(params[:limit]).order("id DESC")
       @total = WarehouseMutation.active_objects.count
     end
     
     
     
     
  end

  def create
    
    params[:warehouse_mutation][:mutation_date] =  parse_date( params[:warehouse_mutation][:mutation_date] )
    
    
    @object = WarehouseMutation.create_object( params[:warehouse_mutation])
 
    if @object.errors.size == 0 
      
      
 
	
      render :json => { :success => true, 
                        :warehouse_mutations => [
                          :id => @object.id, 
                          :code => @object.code ,
                          :description => @object.description , 
                          
                          :warehouse_from_name 	=>		@object.warehouse_from.name ,
                          :warehouse_from_id 		=>		@object.warehouse_from.id ,
                          	
                          :warehouse_to_name 	=>		@object.warehouse_to.name ,
                          :warehouse_to_id 		=>		@object.warehouse_to.id ,
                          	
                          :mutation_date => format_date_friendly(@object.mutation_date)  ,
                          :is_confirmed => @object.is_confirmed,
                          :confirmed_at => format_date_friendly(@object.confirmed_at) 
                          ] , 
                        :total => WarehouseMutation.active_objects.count }  
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
    @object  = WarehouseMutation.find params[:id]
    @total = WarehouseMutation.active_objects.count
  end

  def update
    params[:warehouse_mutation][:mutation_date] =  parse_date( params[:warehouse_mutation][:mutation_date] )
    params[:warehouse_mutation][:confirmed_at] =  parse_date( params[:warehouse_mutation][:confirmed_at] )
    
    @object = WarehouseMutation.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_role?( :warehouse_mutations, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:warehouse_mutation][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_role?( :warehouse_mutations, :unconfirm)
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
      @object.update_object(params[:warehouse_mutation])
    end
    
     
    
    
    
    
    if @object.errors.size == 0 
      @total = WarehouseMutation.active_objects.count
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
    @object = WarehouseMutation.find(params[:id])
    @object.delete_object

    if   not @object.persisted? 
      render :json => { :success => true, :total => WarehouseMutation.active_objects.count }  
    else
      render :json => { :success => false, :total => WarehouseMutation.active_objects.count, 
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
      @objects = WarehouseMutation.where{  
        ( 
           ( code =~ query )  
         )
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = WarehouseMutation.where{  
        ( 
           ( code =~ query )  
         )
      }.count 
    else
      @objects = WarehouseMutation.where{ 
          (id.eq selected_id)   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = WarehouseMutation.where{ 
          (id.eq selected_id)  
      }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
