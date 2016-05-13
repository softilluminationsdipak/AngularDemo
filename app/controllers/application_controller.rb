class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :null_session ## For API
  protect_from_forgery with: :exception
  ## before_filter :set_cache_headers ## For API

  include ActionView::Helpers::TextHelper
  respond_to :html, :json

  helper :all
  helper_method :current_account

  def current_account
    @current_account ||= Account.find_by(full_domain: request.host)
    @current_account
  end

	private

  def set_cache_headers
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

end
