class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, ,
  # :lockable, :timeoutable and :omniauthable,:registerable,

  devise :database_authenticatable, :registerable, :confirmable, 
         :recoverable, :rememberable, :trackable, :validatable

  ## Relationships
  has_many :auth_tokens, :dependent => :destroy

  belongs_to :account
  accepts_nested_attributes_for :account, allow_destroy: true

  
  ## Validations
  validates :username, presence: true, length: { in: 3..40 }, uniqueness: { scope: :account_id }
  validates :username, format: { with: /\A\w[\w\.\-_@]+\z/, message: "use only letters, numbers, and .-_@ please.".freeze }

  validates :firstname, length: { maximum: 100, allow_nil: true }
  validates :lastname, length: { maximum: 100, allow_nil: true }

  validates :email, uniqueness: {scope: :account_id }
  
  ## Methods
  def display_errors
    errors.full_messages.join(', ')
  end

  def username=(value)
    write_attribute :username, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  class << self
    def authenticate_user_with_auth(email, password) ## For API
      return nil unless email.present? or password.present?
      user = User.find_by(email: email)
      (user.present? && user.valid_password?(password))? user : nil
    end

    def invalid_credentials
      "Email or Password is not valid"
    end

    def authenticate_account_with_email_and_password(user_hash)

      login     = user_hash['email']
      password  = user_hash['password']
      
      return nil, 'both' if !login.present? && !password.present?
      return nil, 'login' unless login.present?
      return nil, 'password' unless password.present?
      
      if login.present? && password.present?
        user = User.where(['lower(username) = :value OR lower(email) = :value', { value: login.downcase }]).first
        if user.present? && user.valid_password?(password)
          return user, nil
        elsif user.present? && !user.valid_password?(password)
          return nil, 'Password is invalid.'
        else
          return nil, 'User not found.'
        end
      end

    end
  end

  def is_confirmed_user?
    confirmation_token.nil? && !confirmed_at.nil?
  end

  def fullname
    if firstname.present? && lastname.present?
      "#{firstname} #{lastname}"
    elsif username.present?
      username
    else
      email
    end
  end
end
