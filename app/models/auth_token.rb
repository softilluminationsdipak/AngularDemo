class AuthToken < ActiveRecord::Base
	## Relationships
	belongs_to :user

  ## Validations
  validates :authentication_token, :user_id, presence: true

  ## Scopes  
  scope :current_auth_token_for_user, -> (user_id, token) { where('user_id = ? and authentication_token = ?', user_id, token) }

	class << self
		def generate_unique_token
   		token = SecureRandom.hex(20)
    	while AuthToken.find_by(authentication_token: token)
      	token = SecureRandom.hex(20)
    	end
    	token
    end

    def find_user_from_auth_token(token)
      u = where(authentication_token: token).includes(:user)    
      (u.present? && u.try(:first).try(:user).present?)? u.try(:first).try(:user) : nil   
    end
	end
end
