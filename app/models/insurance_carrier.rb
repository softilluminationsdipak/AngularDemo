class InsuranceCarrier < ActiveRecord::Base
	
	include Contactable
	include Addressable

  extend FriendlyId
  friendly_id :name, use: :slugged

	acts_as_contactable
	acts_as_addressable
	acts_as_paranoid

	## Relationship
	belongs_to :account

	belongs_to :address, validate: false, dependent: :destroy
	accepts_nested_attributes_for :address
	
	belongs_to :legacy_id_label

	## Validations
	validates :name, presence: true, uniqueness: {scope: :account_id}

	## Scopes
	scope :alphabetically, -> { order('name	ASC')}

	## Methods
	def insurance_carrier_type
    carrier_types = AppConfig['options']['carrier_types'].invert
    carrier_types[insurance_carrier_type_code]
  end

end
