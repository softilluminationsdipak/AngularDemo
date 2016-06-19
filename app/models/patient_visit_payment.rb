class PatientVisitPayment < ActiveRecord::Base
	acts_as_paranoid

	## Relationships
	belongs_to :source_patient_visit_detail, class_name: 'PatientVisitDetail'
	belongs_to :destination_patient_visit_detail, class_name: 'PatientVisitDetail'

	## Validations
	validates :amount_cents, presence: true
end
