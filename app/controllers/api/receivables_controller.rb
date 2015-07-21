class Api::ReceivablesController < Api::BaseApiController
  
  def index
     
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
        
        
        @objects = Receivable.active_objects.joins(:exchange,:contact).where{
          (
            ( source_class =~  livesearch )  | 
            ( source_code =~ livesearch ) | 
            ( contact.name =~ livesearch ) | 
            ( exchange.name =~ livesearch ) 
          )

        }.page(params[:page]).per(params[:limit]).order("id DESC")

        @total = Receivable.active_objects.joins(:exchange,:contact).where{
          (
             ( source_class =~  livesearch )  | 
            ( source_code =~ livesearch ) | 
            ( contact.name =~ livesearch ) | 
            ( exchange.name =~ livesearch ) 
          )
        }.count
   
    else
      puts "In this shite"
      @objects = Receivable.page(params[:page]).per(params[:limit]).order("id DESC")
      @total = Receivable.count 
    end
    
    
    # render :json => { :receivables => @objects , :total => @total , :success => true }
  end

  def create
    @object = Receivable.create_object( params[:receivable] )
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :receivables => [@object] , 
                        :total => Receivable.active_objects.count  }  
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

  def update
    @object = Receivable.find(params[:id]) 
    

    @object.update_object( params[:receivable] )
    
     
    if @object.errors.size == 0 
      @total = Receivable.active_objects.count
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
  
  def show
    @object = Receivable.find_by_id params[:id]
    @total = Receivable.count
  end

  def destroy
    @object = Receivable.find(params[:id])
    
    begin
      ActiveRecord::Base.transaction do 
        @object.delete_object 
      end
    rescue ActiveRecord::ActiveRecordError  
    else
    end
    
    

    if not @object.persisted?  
      render :json => { :success => true, :total => Receivable.active_objects.count }  
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
  
  
  def search
    search_params = params[:query]
    selected_id = params[:selected_id]
    if params[:selected_id].nil?  or params[:selected_id].length == 0 
      selected_id = nil
    end
    
    query = "%#{search_params}%"
    # on PostGre SQL, it is ignoring lower case or upper case 
    
    if  selected_id.nil?
      query = Receivable.joins(:exchange,:contact).where{ 
          ( source_class =~  query )  | 
          ( source_code =~ query ) | 
          ( contact.name =~ query ) | 
          ( exchange.name =~ query ) 
                              }
                              
      if params[:contact_id].present?
        object = Contact.find_by_id params[:contact_id]
        if not object.nil?  
          query = query.where(:contact_id => object.id )
        end
      end    
      
      
      # @objects = Receivable.joins(:exchange,:contact).where{ 
      #     ( source_class =~  query )  | 
      #     ( source_code =~ query ) | 
      #     ( contact.name =~ query ) | 
      #     ( exchange.name =~ query ) 
      #                         }.
      #                   page(params[:page]).
      #                   per(params[:limit]).
      #                   order("id DESC")
                        
      # @total = Receivable.joins(:exchange,:contact).where{ 
      #     ( source_class =~  query )  | 
      #     ( source_code =~ query ) | 
      #     ( contact.name =~ query ) | 
      #     ( exchange.name =~ query ) 
        
      #                         }.count
      @objects = query.page(params[:page]).
                  per(params[:limit]).
                  order("id DESC")
      @total = query.count 
    else
      @objects = Receivable.joins(:exchange,:contact).where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = Receivable.joins(:exchange,:contact).where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
