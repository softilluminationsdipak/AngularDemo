class Users::SessionsController < Devise::SessionsController
  layout 'login'
  respond_to :html, :json
# before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    ## current_account = Account.find_by_full_domain(request.host)
    @user, @message = current_account.present? && current_account.users.present? && current_account.users.authenticate_account_with_email_and_password(params[:user])
    if @user.present? && !@message.present? && @user.is_confirmed_user?
      sign_out_all_scopes
      sign_in(@user)
      if @user.system_admin?
        redirect_to admin_dashboard_path, notice: "You have been logged in successfully. Welcome to EMR!"
      else
        redirect_to user_dashboard_path, notice: "You have been logged in successfully. Welcome to EMR!"
      end
    elsif @user.present? && !@user.is_confirmed_user?
      redirect_to new_session_path, flash: {error: 'Please confirmed your account to login.'}
    else
      redirect_to new_session_path, flash: {error: 'Invalid credential.'}
    end    
  end

  # DELETE /resource/sign_out
  def destroy
    current_account   = nil
    current_clinic    = nil
    sign_out_all_scopes
    redirect_to root_path, notice: 'successfully sign out!'    
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
