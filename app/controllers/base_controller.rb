class BaseController < ApplicationController
	before_action :authenticate_user!
	layout 'dashboard'
	
	def dashboard
	end
end
