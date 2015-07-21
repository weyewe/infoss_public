class PaymentVouchersController < ApplicationController 
  
 
  def show
    @object = PaymentVoucher.find(params[:id])
    
    @document_title = "Payment Request"
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "payment_voucher_#{@object.nomor_surat}",
        :template => 'payment_vouchers/show.pdf.erb',
        :layout => 'pdf.html.erb',
        # :layout => 'balance_sheet_pdf.html.erb',
        :show_as_html => params[:debug].present?
      end
    end
  end
end