class Api::BankAdministrationsController < Api::BaseApiController
  
  def index
     
     
     if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       @objects = BankAdministration.active_objects.joins(:cash_bank).where{
         (
           ( code =~ livesearch)  | 
           ( no_bukti =~ livesearch)  | 
           ( cash_bank.name =~ livesearch)  
         )

       }.page(params[:page]).per(params[:limit]).order("id DESC")

       @total = BankAdministration.active_objects.joins(:cash_bank).where{
         (
           ( code =~ livesearch)  | 
           ( no_bukti =~ livesearch)  | 
           ( cash_bank.name =~ livesearch)  
         )
       }.count
 

     else
       @objects = BankAdministration.active_objects.joins(:cash_bank).page(params[:page]).per(params[:limit]).order("id DESC")
       @total = BankAdministration.active_objects.count
     end
     
     
     
     
  end

  def create
    
    params[:bank_administration][:administration_date] =  parse_date( params[:bank_administration][:administration_date] )
    
    
    @object = BankAdministration.create_object( params[:bank_administration])
 
    if @object.errors.size == 0 
      
      render :json => { :success => true, 
                        :bank_administrations => [
                          :id => @object.id, 
                          :code => @object.code ,
                          :no_bukti => @object.no_bukti , 
                          :cash_bank_id => @object.cash_bank_id , 
                          :cash_bank_name => @object.cash_bank.name ,  
                          :exchange_rate_amount => @object.exchange_rate_amount , 
                          :amount => @object.amount , 
                          :administration_date => format_date_friendly(@object.administration_date)  ,
                          :is_confirmed => @object.is_confirmed,
                          :confirmed_at => format_date_friendly(@object.confirmed_at) 
                          ] , 
                        :total => BankAdministration.active_objects.count }  
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
    @object  = BankAdministration.find params[:id]
    render :json => { :success => true,   
                      :bank_administrations => [
                          :id => @object.id, 
                          :code => @object.code ,
                          :no_bukti => @object.no_bukti , 
                          :cash_bank_id => @object.cash_bank_id , 
                          :cash_bank_name => @object.cash_bank.name , 
                          :exchange_rate_amount => @object.exchange_rate_amount , 
                          :amount => @object.amount , 
                          :administration_date => format_date_friendly(@object.administration_date)  ,
                          :is_confirmed => @object.is_confirmed,
                          :confirmed_at => format_date_friendly(@object.confirmed_at) 
                        
                        ],
                      :total => BankAdministration.active_objects.count  }
  end

  def update
    params[:bank_administration][:administration_date] =  parse_date( params[:bank_administration][:administration_date] )
    params[:bank_administration][:confirmed_at] =  parse_date( params[:bank_administration][:confirmed_at] )
    
    @object = BankAdministration.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_role?( :bank_administrations, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:bank_administration][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_role?( :bank_administrations, :unconfirm)
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
      @object.update_object(params[:bank_administration])
    end
    
     
    
    
    
    
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :bank_administrations => [
                            :id => @object.id, 
                            :code => @object.code ,
                            :no_bukti => @object.no_bukti , 
                            :cash_bank_id => @object.cash_bank_id , 
                            :cash_bank_name => @object.cash_bank.name , 
                            :exchange_rate_amount => @object.exchange_rate_amount , 
                            :amount => @object.amount , 
                            :administration_date => format_date_friendly(@object.administration_date)  ,
                            :is_confirmed => @object.is_confirmed,
                            :confirmed_at => format_date_friendly(@object.confirmed_at) 
                          ],
                        :total => BankAdministration.active_objects.count  } 
    else
      
      msg = {
        :success => false, 
        :message => {
          :errors => extjs_error_format( @object.errors )  
        }
      }
      
      render :json => msg
    end
  end
  
   

  def destroy
    @object = BankAdministration.find(params[:id])
    @object.delete_object

    if   not @object.persisted? 
      render :json => { :success => true, :total => BankAdministration.active_objects.count }  
    else
      render :json => { :success => false, :total => BankAdministration.active_objects.count, 
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
      @objects = BankAdministration.active_objects.joins(:cash_bank).where{  
        ( 
           ( code =~ query)  | 
           ( no_bukti =~ query)  | 
           ( cash_bank.name =~ query)  
         )
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = BankAdministration.active_objects.joins(:cash_bank).where{  
        ( 
           ( code =~ query)  | 
           ( no_bukti =~ query)  | 
           ( cash_bank.name =~ query)  
         )
      }.count 
    else
      @objects = BankAdministration.active_objects.joins(:cash_bank).where{ 
          (id.eq selected_id)   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = BankAdministration.active_objects.joins(:cash_bank).where{ 
          (id.eq selected_id)  
      }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
