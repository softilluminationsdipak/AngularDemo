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

	has_many :primary_patient_cases, foreign_key: :primary_insurance_carrier_id, class_name: 'PatientCase'
	has_many :secondary_patient_cases, foreign_key: :secondary_insurance_carrier_id, class_name: 'PatientCase'

	## Validations
	validates :name, presence: true, uniqueness: {scope: :account_id}

	## Callbacks

	## Scopes
	scope :alphabetically, -> { order('name	ASC')}
	scope :without_attorneys, -> {where("id NOT IN (?)", 
		if att_ids = Attorney.where("insurance_carrier_id IS NOT NULL").select("DISTINCT insurance_carrier_id").map(&:insurance_carrier_id)
			att_ids
		else
			[-1]
		end
	)}

	## Methods
	def insurance_carrier_type
    carrier_types = AppConfig['options']['carrier_types'].invert
    carrier_types[insurance_carrier_type_code]
  end

end
