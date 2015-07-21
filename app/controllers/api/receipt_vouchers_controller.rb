class Api::ReceiptVouchersController < Api::BaseApiController
  
  def index
     
     
     if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       @objects = ReceiptVoucher.active_objects.joins(:contact,:cash_bank).where{
         (
           ( code =~ livesearch)  | 
           ( no_bukti =~ livesearch)  | 
           ( gbch_no =~ livesearch)  | 
           ( contact.name =~  livesearch) | 
           ( cash_bank.name =~  livesearch) | 
           ( cash_bank.exchange.name =~  livesearch)
         )

       }.page(params[:page]).per(params[:limit]).order("id DESC")

       @total = ReceiptVoucher.active_objects.joins(:contact,:cash_bank).where{
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
       @objects = ReceiptVoucher.active_objects.joins(:contact,:cash_bank).page(params[:page]).per(params[:limit]).order("id DESC")
       @total = ReceiptVoucher.active_objects.count
     end
     
     
     
     
  end

  def create
    
    params[:receipt_voucher][:receipt_date] =  parse_date( params[:receipt_voucher][:receipt_date] )
    params[:receipt_voucher][:due_date] =  parse_date( params[:receipt_voucher][:due_date] )
    
    
    @object = ReceiptVoucher.create_object( params[:receipt_voucher])
 
    if @object.errors.size == 0 
      
      render :json => { :success => true, 
                        :receipt_vouchers => [
                          :id => @object.id, 
                          :code => @object.code ,
                          :contact_id => @object.contact_id , 
                          :contact_name => @object.contact.name , 
                          :cash_bank_id => @object.cash_bank_id,
                          :cash_bank_name => @object.cash_bank.name,
                          :status_pembulatan => @object.status_pembulatan,
                          :receipt_date => format_date_friendly(@object.receipt_date)  ,
                          :amount => @object.amount ,
                          :rate_to_idr => @object.rate_to_idr,
                          :total_pph_23 => @object.total_pph_23,
                          :biaya_bank => @object.biaya_bank,
                          :pembulatan => @object.pembulatan,
                          :no_bukti => @object.no_bukti , 
                          :gbch_no => @object.gbch_no,
                          :is_gbch => @object.is_gbch,
                          :due_date => format_date_friendly(@object.due_date) ,
                          :is_confirmed => @object.is_confirmed,
                          :confirmed_at => format_date_friendly(@object.confirmed_at)  
                          ] , 
                        :total => ReceiptVoucher.active_objects.count }  
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
    @object  = ReceiptVoucher.find params[:id]
    @total = ReceiptVoucher.active_objects.count
  end

  def update
    params[:receipt_voucher][:transaction_datetime] =  parse_date( params[:receipt_voucher][:transaction_datetime] )
    params[:receipt_voucher][:confirmed_at] =  parse_date( params[:receipt_voucher][:confirmed_at] )
    params[:receipt_voucher][:reconciliation_date] =  parse_date( params[:receipt_voucher][:reconciliation_date] )
    
    @object = ReceiptVoucher.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_role?( :receipt_vouchers, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:receipt_voucher][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_role?( :receipt_vouchers, :unconfirm)
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
      
      if not current_user.has_role?( :receipt_vouchers, :unconfirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.reconcile_object(:reconciliation_date => params[:receipt_voucher][:reconciliation_date] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
    
    elsif params[:unreconcile].present?    
      
      if not current_user.has_role?( :receipt_vouchers, :unconfirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.unreconcileObject
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
    
    else
      @object.update_object(params[:receipt_voucher])
    end
    
     
    
    
    
    
    if @object.errors.size == 0 
      @total = ReceiptVoucher.active_objects.count
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
    @object = ReceiptVoucher.find(params[:id])
    @object.delete_object

    if   not @object.persisted? 
      render :json => { :success => true, :total => ReceiptVoucher.active_objects.count }  
    else
      render :json => { :success => false, :total => ReceiptVoucher.active_objects.count, 
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
      @objects = ReceiptVoucher.joins(:contact,:cash_bank).where{  
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
                        
      @total = ReceiptVoucher.joins(:contact,:cash_bank).where{  
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
      @objects = ReceiptVoucher.joins(:contact,:cash_bank).where{ 
          (id.eq selected_id)   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = ReceiptVoucher.joins(:contact,:cash_bank).where{ 
          (id.eq selected_id)  
      }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
