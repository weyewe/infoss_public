class PurchaseInvoicesController < ApplicationController 
  
 
  def show
        
    user = User.find_by_authentication_token params[:auth_token]
    if user.nil?
      redirect_to root_url 
      return
    end
    
    @object = PurchaseInvoice.find(params[:id])
    @contact = @object.purchase_receival.purchase_order.contact 
    
    @document_title = "Purchase Invoice"
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "purchase_invoice_#{@object.nomor_surat}",
        :template => 'purchase_invoices/show.pdf.erb',
        :layout => 'pdf.html.erb',
        # :layout => 'balance_sheet_pdf.html.erb',
        :show_as_html => params[:debug].present?
      end
    end
  end
end