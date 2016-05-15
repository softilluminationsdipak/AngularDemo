class ClinicPreference < ActiveRecord::Base

	serialize :insurance_carrier_assignment_policy, Array

	## Relationships
	belongs_to :clinic

	## Validation
	validates :clinic_id, presence: true	
end
