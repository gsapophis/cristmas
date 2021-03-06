class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def redirect_to_back(default = root_path)
    request.env["HTTP_REFERER"].present? and request.env["HTTP_REFERER"] != request.env["REQUEST_URI"] ? redirect_to(:back) : redirect_to(default)
  end

  protected
  def authenticate_user!
    user_signed_in? ? super : redirect_to(root_path, notice: 'You are not authorized')
  end
end
