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
