class DeliveryOrdersController < ApplicationController 
  
 
  def show
    
    
    user = User.find_by_authentication_token params[:auth_token]
    if user.nil?
      redirect_to root_url 
      return
    end
    
    @object = DeliveryOrder.find(params[:id])
    @contact = @object.sales_order.contact 
    
    @document_title = "DELIVERY ORDER"
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "delivery_order_#{@object.nomor_surat}",
        :template => 'delivery_orders/show.pdf.erb',
        :layout => 'pdf.html.erb',
        # :layout => 'balance_sheet_pdf.html.erb',
        :show_as_html => params[:debug].present?
      end
    end
  end
end