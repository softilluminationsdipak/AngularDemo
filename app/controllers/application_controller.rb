class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :null_session ## For API
  protect_from_forgery with: :exception
  ## before_filter :set_cache_headers ## For API
  before_filter :only_admin_access_login

  include ActionView::Helpers::TextHelper
  respond_to :html, :json

  helper :all
  helper_method :current_account

  def current_account
    @current_account ||= Account.find_by(full_domain: request.host)
    @current_account
  end

  def only_admin_access_login
    if request.subdomain.downcase == 'admin' && ['users/registrations', 'users/passwords'].include?(params[:controller])
      redirect_to root_path
    end
  end

	private

  def set_cache_headers
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  protected

  def after_sign_in_path_for(_resource)
    if current_user.system_admin?
      return admin_dashboard_path
    end
  end
  
end
