class Api::CashBankMutationsController < Api::BaseApiController
  
  def index
     
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
        
        
        @objects = CashBankMutation.where{
          (
            ( no_bukti =~  livesearch )  | 
            ( source_cash_bank.name =~ livesearch ) | 
            ( target_cash_bank.name =~ livesearch ) 
          )

        }.page(params[:page]).per(params[:limit]).order("id DESC")

        @total = CashBankMutation.where{
          (
            ( no_bukti =~  livesearch )  | 
            ( source_cash_bank.name =~ livesearch ) | 
            ( target_cash_bank.name =~ livesearch )
          )
        }.count
   
    else
      puts "In this shite"
      @objects = CashBankMutation.page(params[:page]).per(params[:limit]).order("id DESC")
      @total = CashBankMutation.count 
    end
    
    
    # render :json => { :cash_bank_mutations => @objects , :total => @total , :success => true }
  end

  def create
    params[:cash_bank_mutation][:mutation_date] =  parse_date( params[:cash_bank_mutation][:mutation_date] )
    params[:cash_bank_mutation][:confirmed_at] =  parse_date( params[:cash_bank_mutation][:confirmed_at] )
    @object = CashBankMutation.create_object( params[:cash_bank_mutation] )
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :cash_bank_mutations => [@object] , 
                        :total => CashBankMutation.active_objects.count  }  
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
    params[:cash_bank_mutation][:mutation_date] =  parse_date( params[:cash_bank_mutation][:mutation_date] )
    params[:cash_bank_mutation][:confirmed_at] =  parse_date( params[:cash_bank_mutation][:confirmed_at] )
    
    @object = CashBankMutation.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_role?( :cash_bank_mutations, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:cash_bank_mutation][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_role?( :cash_bank_mutations, :unconfirm)
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
      @object.update_object(params[:cash_bank_mutation])
    end
    
     
     
    if @object.errors.size == 0 
      @total = CashBankMutation.active_objects.count
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
    @object = CashBankMutation.find_by_id params[:id]
    @total = CashBankMutation.count
  end

  def destroy
    @object = CashBankMutation.find(params[:id])
    
    begin
      ActiveRecord::Base.transaction do 
        @object.delete_object 
      end
    rescue ActiveRecord::ActiveRecordError  
    else
    end
    
    

    if not @object.persisted?  
      render :json => { :success => true, :total => CashBankMutation.active_objects.count }  
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
      @objects = CashBankMutation.where{ 
          ( no_bukti =~  query )  | 
          ( source_cash_bank.name =~ query ) | 
          ( target_cash_bank.name =~ query ) 
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = CashBankMutation.where{ 
          ( no_bukti =~  query )  | 
          ( source_cash_bank.name =~ query ) | 
          ( target_cash_bank.name =~ query ) 
        
                              }.count
    else
      @objects = CashBankMutation.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = CashBankMutation.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
