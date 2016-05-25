class Users::RegistrationsController < Devise::RegistrationsController
# before_action :configure_sign_up_params, only: [:create]
# before_action :configure_account_update_params, only: [:update]

  before_action :build_user, only: [:new, :create]
  before_action :build_account, only: [:new, :create]

  layout 'login'

  # GET /resource/sign_up
  def new    
  end

  # POST /resource
  def create
    if @user.save
      session[:domain] = @user.account.full_domain
      set_flash_message :notice, :created
      redirect_to thanks_path, notice: 'Successfully created account.'
    else
      render action: :new
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def build_user
    if params[:user].present?
      @user = User.new(user_params)
    else
      @user = User.new
    end
    @user.admin = true    
  end

  def build_account
    @account = @user.account.present? ? @user.account : @user.build_account
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :admin, :account_id, :name, :contact_id, :user_role_id, account_attributes: [:name, :full_domain, :domain])
  end

end
