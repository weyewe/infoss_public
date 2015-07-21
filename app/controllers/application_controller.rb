class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    tenant_outstanding_invoice_url 
  end

  def after_sign_out_path_for( resource )
  	root_url
  end


  def validate_auth_token
    user = User.find_by_authentication_token params[:auth_token]
    if user.nil?
      redirect_to root_url 
      return
    end
  end

  protect_from_forgery with: :exception
end
