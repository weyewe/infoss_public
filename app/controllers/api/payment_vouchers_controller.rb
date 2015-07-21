class Api::PaymentVouchersController < Api::BaseApiController
  
  def index
     
     
     if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       @objects = PaymentVoucher.active_objects.joins(:contact,:cash_bank).where{
         (
           ( code =~ livesearch)  | 
           ( no_bukti =~ livesearch)  | 
           ( gbch_no =~ livesearch)  | 
           ( contact.name =~  livesearch) | 
           ( cash_bank.name =~  livesearch) | 
           ( cash_bank.exchange.name =~  livesearch)
         )

       }.page(params[:page]).per(params[:limit]).order("id DESC")

       @total = PaymentVoucher.active_objects.joins(:contact,:cash_bank).where{
         (
           ( code =~ livesearch)  | 
           ( no_bukti =~ livesearch)  | 
           ( gbch_no =~ livesearch)  | 
           ( contact.name =~  livesearch) | 
           ( cash_bank.name =~  livesearch) | 
           ( cash_bank.exchange.name =~  livesearch)
         )
       }.count
 

     else
       @objects = PaymentVoucher.active_objects.joins(:contact,:cash_bank).page(params[:page]).per(params[:limit]).order("id DESC")
       @total = PaymentVoucher.active_objects.count
     end
     
     
     
     
  end

  def create
    
    params[:payment_voucher][:payment_date] =  parse_date( params[:payment_voucher][:payment_date] )
    params[:payment_voucher][:due_date] =  parse_date( params[:payment_voucher][:due_date] )
    
    
    @object = PaymentVoucher.create_object( params[:payment_voucher])
 
    if @object.errors.size == 0 
      
      render :json => { :success => true, 
                        :payment_vouchers => [
                          :id => @object.id, 
                          :code => @object.code ,
                          :contact_id => @object.contact_id , 
                          :contact_name => @object.contact.name , 
                          :cash_bank_id => @object.cash_bank_id,
                          :cash_bank_name => @object.cash_bank.name,
                          :status_pembulatan => @object.status_pembulatan,
                          :payment_date => format_date_friendly(@object.payment_date)  ,
                          :amount => @object.amount ,
                          :rate_to_idr => @object.rate_to_idr,
                          :total_pph_23 => @object.total_pph_23,
                          :total_pph_21 => @object.total_pph_21,
                          :biaya_bank => @object.biaya_bank,
                          :pembulatan => @object.pembulatan,
                          :no_bukti => @object.no_bukti , 
                          :gbch_no => @object.gbch_no,
                          :is_gbch => @object.is_gbch,
                          :due_date => format_date_friendly(@object.due_date) ,
                          :is_confirmed => @object.is_confirmed,
                          :confirmed_at => format_date_friendly(@object.confirmed_at) 
                          ] , 
                        :total => PaymentVoucher.active_objects.count }  
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
    @object  = PaymentVoucher.find params[:id]
    @total = PaymentVoucher.active_objects.count
  end

  def update
    params[:payment_voucher][:payment_date] =  parse_date( params[:payment_voucher][:payment_date] )
    params[:payment_voucher][:confirmed_at] =  parse_date( params[:payment_voucher][:confirmed_at] )
    params[:payment_voucher][:reconciliation_date] =  parse_date( params[:payment_voucher][:reconciliation_date] )
    @object = PaymentVoucher.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_role?( :payment_vouchers, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:payment_voucher][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_role?( :payment_vouchers, :unconfirm)
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
    
    elsif params[:reconcile].present?    
      
      if not current_user.has_role?( :payment_vouchers, :unconfirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.reconcile_object(:reconciliation_date => params[:payment_voucher][:reconciliation_date] )
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
    elsif params[:unreconcile].present?    
      
      if not current_user.has_role?( :payment_vouchers, :unconfirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.unreconcile_object
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
    else
      @object.update_object(params[:payment_voucher])
    end
    
     
    
    
    
    
    if @object.errors.size == 0 
      @total = PaymentVoucher.active_objects.count
     
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
    @object = PaymentVoucher.find(params[:id])
    @object.delete_object

    if   not @object.persisted? 
      render :json => { :success => true, :total => PaymentVoucher.active_objects.count }  
    else
      render :json => { :success => false, :total => PaymentVoucher.active_objects.count, 
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
      @objects = PaymentVoucher.joins(:contact,:cash_bank).where{  
        ( 
           ( code =~ query)  | 
           ( no_bukti =~ query)  | 
           ( gbch_no =~ query)  | 
           ( contact.name =~  query) | 
           ( cash_bank.name =~  query) | 
           ( cash_bank.exchange.name =~  query)
         )
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = PaymentVoucher.joins(:contact,:cash_bank).where{  
        ( 
           ( code =~ query)  | 
           ( no_bukti =~ query)  | 
           ( gbch_no =~ query)  | 
           ( contact.name =~  query) | 
           ( cash_bank.name =~  query) | 
           ( cash_bank.exchange.name =~  query)
         )
      }.count 
    else
      @objects = PaymentVoucher.joins(:contact,:cash_bank).where{ 
          (id.eq selected_id)   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = PaymentVoucher.joins(:contact,:cash_bank).where{ 
          (id.eq selected_id)  
      }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
