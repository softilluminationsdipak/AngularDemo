class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, ,
  # :lockable, :timeoutable and :omniauthable,:registerable,

  devise :database_authenticatable, :registerable, :confirmable, 
         :recoverable, :rememberable, :trackable, :validatable

  ## Relationships
  has_many :auth_tokens, :dependent => :destroy

  ## Methods
  def display_errors
    errors.full_messages.join(', ')
  end

  class << self
    def authenticate_user_with_auth(email, password)
      return nil unless email.present? or password.present?
      user = User.find_by(email: email)
      (user.present? && user.valid_password?(password))? user : nil
    end

    def invalid_credentials
      "Email or Password is not valid"
    end
  end

end
