class Api::V1::RegistrationsController < Api::V1::BaseController
	skip_before_action 	:login_required
	skip_before_filter  :verify_authenticity_token

	def create ## api/v1/registrations
		@user = User.new(user_params)
		@user.skip_confirmation!
		if @user.save
			@auth_token = @user.auth_tokens.create(authentication_token: AuthToken.generate_unique_token)
      render  status: 200, json: { 
        success: true, 
        info: "SignUp", 
        user: @user, 
        access_token: @auth_token.authentication_token, 
        auth_token: @auth_token.authentication_token
      }
		else
			render_json({
				result: {
					messages: @user.display_errors,
					status: 404
				}
			}.to_json)
		end
	end
	
	private

	def user_params
		params.require(:user).permit(:firstname, :lastname, :email, :password, :password_confirmation, :username)
	end

end
