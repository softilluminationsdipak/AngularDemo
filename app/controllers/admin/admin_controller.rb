class Admin::AdminController < ApplicationController
	before_action :authenticate_user!
	#before_action :only_admin_access
	
	layout 'admin_dashboard'

  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end
  
	def dashboard
	end

end
