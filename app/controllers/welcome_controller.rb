class WelcomeController < ApplicationController

	layout 'frontpage', only: [:home, :plans]

  def index
  end

  def home
  	@plans = Plan.all
  end

  def thanks
  	if session[:domain].present?
  		@domain = session[:domain]
  		session[:domain] = nil
      render layout: 'login'
  	else
  		redirect_to plans_path
  	end  	
  end

  def plans
  	@plans = Plan.all
  end
end
