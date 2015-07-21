class PaymentRequestsController < ApplicationController 
  
 
  def show
    @object = PaymentRequest.find(params[:id])
    
    @document_title = "Payment Request"
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "payment_request_#{@object.nomor_surat}",
        :template => 'payment_requests/show.pdf.erb',
        :layout => 'pdf.html.erb',
        # :layout => 'balance_sheet_pdf.html.erb',
        :show_as_html => params[:debug].present?
      end
    end
  end
end