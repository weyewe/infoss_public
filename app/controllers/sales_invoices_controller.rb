class SalesInvoicesController < ApplicationController 
  
 
  def show
        
    user = User.find_by_authentication_token params[:auth_token]
    if user.nil?
      redirect_to root_url 
      return
    end
    
    @object = SalesInvoice.find(params[:id])
    @contact = @object.delivery_order.sales_order.contact 
    
    @document_title = "Invoice"
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "sales_invoice_#{@object.nomor_surat}",
        :template => 'sales_invoices/show.pdf.erb',
        :layout => 'pdf.html.erb',
        # :layout => 'balance_sheet_pdf.html.erb',
        :show_as_html => params[:debug].present?
      end
    end
  end
end