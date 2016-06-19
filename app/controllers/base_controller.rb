class BaseController < ApplicationController
	before_action :authenticate_user!
	
	include ActionView::Helpers::TextHelper

	layout 'dashboard'

  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end

	def dashboard
	end

end
