class Address < ActiveRecord::Base
	## Relationship
	belongs_to :addressable, polymorphic: true

	## Validations
	validates :city, presence: true, if: :should_validate_city?
	validates :state, presence: true, if: :should_validate_state?
  validates :zip, presence: true, if: :should_validate_zip?
  validates :street, presence: true, if: :should_validate_street?	
	validates :state, length: {is: 2, allow_blank: true}

	## Scopes
	default_scope { order('addresses.updated_at DESC') } 

	## Methods

  def line1
    [street, street2].compact.join(" ")
  end
  
  def line2
    [city, state, zip].compact.join(" ")
  end

  def one_liner
    "#{city}, #{state} #{zip} #{street}"
  end

	def should_validate_city?
		false
	end

	def should_validate_state?
    false
  end

  def should_validate_zip?
    false
  end

  def should_validate_street?
    false
  end

  def address
    address = []
    address << state unless state.blank?
    address << zip unless zip.blank?
    address << street unless street.blank?
    address << street2 unless street2.blank?

    address.join(' ')  	
  end
  alias :to_s :address
	
end
