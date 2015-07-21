class PurchaseReceivalsController < ApplicationController 
  
 
  def show
        
    user = User.find_by_authentication_token params[:auth_token]
    if user.nil?
      redirect_to root_url 
      return
    end
    
    @object = PurchaseReceival.find(params[:id])
    @contact = @object.purchase_order.contact
    
    @document_title = "Bukti Penerimaan Barang"
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "purchase_receival_#{@object.nomor_surat}",
        :template => 'purchase_receivals/show.pdf.erb',
        :layout => 'pdf.html.erb',
        # :layout => 'balance_sheet_pdf.html.erb',
        :show_as_html => params[:debug].present?
      end
    end
  end
end