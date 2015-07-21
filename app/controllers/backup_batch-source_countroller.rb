class BatchSourcesController < Api::BaseApiController
  
  def index
     
     
     query = BatchSource.active_objects.joins(:item )
     

     
     @objects =  query.page(params[:page]).per(params[:limit]).order("id DESC")
     @total = query.count 
     
     
     
     
  end


  def show
    @object  = BatchSource.find params[:id]
    render :json => { :success => true,   
                      :batch_sources => [
                          :id => @object.id, 
                          :code => @object.code ,
                          :nomor_surat => @object.nomor_surat , 
                          :sales_date => format_date_friendly(@object.sales_date)  ,
                          :is_confirmed => @object.is_confirmed,
                          :confirmed_at => format_date_friendly(@object.confirmed_at),
                          :contact_id => @object.contact_id,
                          :exchange_id => @object.exchange_id,
                          :employee_id => @object.employee_id
                        
                        ],
                      :total => BatchSource.active_objects.count  }
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
      @objects = BatchSource.where{  
        ( 
           ( code =~ query )  
         )
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = BatchSource.where{  
        ( 
           ( code =~ query )  
         )
      }.count 
    else
      @objects = BatchSource.where{ 
          (id.eq selected_id)   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = BatchSource.where{ 
          (id.eq selected_id)  
      }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
