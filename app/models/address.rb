class Address < ActiveRecord::Base
	## Relationship
	belongs_to :addressable, polymorphic: true

	## Validations
	validates :city, presence: true, if: :should_validate_city?
	validates :state, presence: true, if: :should_validate_state?
  validates :zipcode, presence: true, if: :should_validate_zip?
  validates :street, presence: true, if: :should_validate_street?	
	validates :state, length: {is: 2, allow_blank: true}

	## Scopes
	default_scope { order('addresses.updated_at DESC') } 

	## Methods

  def line1
    if street.present? || street2.present?
      [street, street2].compact.join(", ")
    else
      ''
    end
  end
  
  def line2
    if city.present? || state.present? || zipcode.present?
      [city, state, zipcode].compact.join(", ")
    else
      ''
    end
  end

  def one_liner
    "#{city}, #{state} #{zipcode} #{street}"
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
    address << zipcode unless zipcode.blank?
    address << street unless street.blank?
    address << street2 unless street2.blank?

    address.join(' ')  	
  end
  alias :to_s :address
	
end
