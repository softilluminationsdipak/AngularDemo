class Api::V1::SessionsController < Api::V1::BaseController

  before_filter :login_required, only: [:logout]

  def current_user
    auth_token  = AuthToken.find_by(authentication_token: params[:access_token])
    user        = auth_token.user

    render  status: 200, json: { 
      success: true, 
      info: "User", 
      email: user.email,
      firstname: user.firstname,
      lastname: user.lastname,
      username: user.username,
      access_token: auth_token.authentication_token, 
      auth_token: auth_token.authentication_token
    }
  end

  def create ## Login
    user = User.authenticate_user_with_auth(params[:login], params[:password])
    if user.present?
      auth_token = user.auth_tokens.create(authentication_token: AuthToken.generate_unique_token)
      render  status: 200, json: { 
        success: true, 
        info: "Logged in", 
        user: user, 
        access_token: auth_token.authentication_token, 
        auth_token: auth_token.authentication_token
      }
    else
      render_json({
        errors: User.invalid_credentials, 
        status: 404
      }.to_json)
    end
  end

  def logout    
    token = AuthToken.current_auth_token_for_user(@current_user.id, params[:auth_token]).try(:last)
    if token.present?
      token.destroy
      render_json({
        message: "Logout Successfully!",
        status: 200
      }.to_json)
    else
      render_json({
        errors: "No user found with authentication_token = #{params[:auth_token]}",
        status: 401
      }.to_json)
    end    
  end

  def failure
    render  status: 401,
            json: { 
              success: false,
              info: "Login Credentials Failed"
            }
  end
end
