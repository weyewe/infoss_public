class Api::PayablesController < Api::BaseApiController
  
  def index
     
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
        
        
        @objects = Payable.active_objects.joins(:exchange,:contact).where{
          (
            ( source_class =~  livesearch )  | 
            ( source_code =~ livesearch ) | 
            ( contact.name =~ livesearch ) | 
            ( exchange.name =~ livesearch ) 
          )

        }.page(params[:page]).per(params[:limit]).order("id DESC")

        @total = Payable.active_objects.joins(:exchange,:contact).where{
          (
            ( source_class =~  livesearch )  | 
            ( source_code =~ livesearch ) | 
            ( contact.name =~ livesearch ) | 
            ( exchange.name =~ livesearch ) 
          )
        }.count
   
    else
      puts "In this shite"
      @objects = Payable.page(params[:page]).per(params[:limit]).order("id DESC")
      @total = Payable.count 
    end
    
    
    # render :json => { :payables => @objects , :total => @total , :success => true }
  end

  def create
    @object = Payable.create_object( params[:payable] )
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :payables => [@object] , 
                        :total => Payable.active_objects.count  }  
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
    @object = Payable.find(params[:id]) 
    

    @object.update_object( params[:payable] )
    
     
    if @object.errors.size == 0 
      @total = Payable.active_objects.count
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
    @object = Payable.find_by_id params[:id]
    @total = Payable.count
  end

  def destroy
    @object = Payable.find(params[:id])
    
    begin
      ActiveRecord::Base.transaction do 
        @object.delete_object 
      end
    rescue ActiveRecord::ActiveRecordError  
    else
    end
    
    

    if not @object.persisted?  
      render :json => { :success => true, :total => Payable.active_objects.count }  
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
      
      query = Payable.joins(:exchange,:contact).where{ 
        ( source_class =~  query )  | 
        ( source_code =~ query ) | 
        ( contact.name =~ query ) | 
        ( exchange.name =~ query ) 
                              }
                              
      if params[:contact_id].present?
        object = Contact.find_by_id params[:contact_id]
        if not object.nil?  
          puts "banzaiii!!!! contact_id : #{object.id}\n"*5
          query = query.where(:contact_id => object.id )
        end
      end
      
      
      # @objects = Payable.joins(:exchange,:contact).where{ 
      #   ( source_class =~  query )  | 
      #   ( source_code =~ query ) | 
      #   ( contact.name =~ query ) | 
      #   ( exchange.name =~ query ) 
      #                         }.
      #                   page(params[:page]).
      #                   per(params[:limit]).
      #                   order("id DESC")
      
      
    
                        
      # @total = Payable.joins(:exchange,:contact).where{ 
      #   ( source_class =~  query )  | 
      #   ( source_code =~ query ) | 
      #   ( contact.name =~ query ) | 
      #   ( exchange.name =~ query ) 
        
      #                         }.count
                              
      @objects = query.page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
      @total = query.count 
    else
      @objects = Payable.joins(:exchange,:contact).where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = Payable.joins(:exchange,:contact).where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
