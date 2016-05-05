class Api::V1::UsersController < ApplicationController


  before_filter :skip_trackable
  before_filter :authenticate_user!

  def show_current_user
  	current_user = User.last
    render :status => 200,
           :json => { :success => true,
                      :info => "Current User",
                      :user => current_user,
                      :auth_token => 'dipakpanchal',
                      :access_token => 'dipakpanchal'
                  }

  end

end
