class Api::CashBankAdjustmentsController < Api::BaseApiController
  
  def index
     
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
        
        
        @objects = CashBankAdjustment.joins(:cash_bank).where{
        (
          (cash_bank.name =~  livesearch ) | 
          (code =~  livesearch ) |
          (description =~  livesearch ) 
           
        )

        }.page(params[:page]).per(params[:limit]).order("id DESC")

        @total = CashBankAdjustment.joins(:cash_bank).where{
        (
          (cash_bank.name =~  livesearch ) | 
          (code =~  livesearch ) |
          (description =~  livesearch ) 
           
        )
        }.count
   
    else
      puts "In this shite"
      @objects = CashBankAdjustment.joins(:cash_bank).page(params[:page]).per(params[:limit]).order("id DESC")
      @total = CashBankAdjustment.count 
    end
    
    
    # render :json => { :cash_bank_adjustments => @objects , :total => @total , :success => true }
  end

  def create
    params[:cash_bank_adjustment][:adjustment_date] =  parse_date( params[:cash_bank_adjustment][:adjustment_date] )
    params[:cash_bank_adjustment][:confirmed_at] =  parse_date( params[:cash_bank_adjustment][:confirmed_at] )
    @object = CashBankAdjustment.create_object( params[:cash_bank_adjustment] )
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :cash_bank_adjustments => [@object] , 
                        :total => CashBankAdjustment.active_objects.count  }  
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
    params[:cash_bank_adjustment][:adjustment_date] =  parse_date( params[:cash_bank_adjustment][:adjustment_date] )
    params[:cash_bank_adjustment][:confirmed_at] =  parse_date( params[:cash_bank_adjustment][:confirmed_at] )
    
    @object = CashBankAdjustment.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_role?( :cash_bank_adjustments, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:cash_bank_adjustment][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_role?( :cash_bank_adjustments, :unconfirm)
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
      @object.update_object(params[:cash_bank_adjustment])
    end
    
     
     
    if @object.errors.size == 0 
      @total = CashBankAdjustment.active_objects.count
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
    @object = CashBankAdjustment.find_by_id params[:id]
    @total = CashBankAdjustment.count
  end

  def destroy
    @object = CashBankAdjustment.find(params[:id])
    
    begin
      ActiveRecord::Base.transaction do 
        @object.delete_object 
      end
    rescue ActiveRecord::ActiveRecordError  
    else
    end
    
    

    if not @object.persisted?  
      render :json => { :success => true, :total => CashBankAdjustment.active_objects.count }  
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
      @objects = CashBankAdjustment.joins(:cash_bank).where{ 
                                (
                                  (cash_bank.name =~  query ) | 
                                  (code =~  query ) | 
                                  (description =~  query ) 
                                )
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = CashBankAdjustment.joins(:cash_bank).where{ 
                                (
                                  (cash_bank.name =~  query ) | 
                                  (code =~  query ) | 
                                  (description =~  query ) 
                                )
        
                              }.count
    else
      @objects = CashBankAdjustment.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = CashBankAdjustment.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
