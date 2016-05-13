class Users::PasswordsController < Devise::PasswordsController
  layout 'login'
  respond_to :html, :json
  # GET /resource/password/new
  #def new
  #  super
  #end

  # POST /resource/password
  def create
  # super
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      respond_with({}, location: new_session_path)
    else
      respond_with(resource)
    end    
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(resource_params_for_update)
    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      if Devise.sign_in_after_reset_password
        flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
        set_flash_message!(:notice, flash_message)
        sign_in(resource_name, resource)
      else
        set_flash_message!(:notice, :updated_not_active)
      end
      respond_with resource, location: new_session_path
    else
      set_minimum_password_length
      respond_with resource
    end
  end

  def resource_params_for_update
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :reset_password_token)
  end
  private :resource_params

  protected

  def after_resetting_password_path_for(resource)
    super(resource)
  end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
