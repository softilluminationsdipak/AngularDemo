class PatientBill < ActiveRecord::Base
	acts_as_paranoid

	## Relationship
	belongs_to :patient_case
	belongs_to :insurance_carrier
	belongs_to :provider

	has_many :primary_patient_visits, class_name: 'PatientVisit', foreign_key: :primary_patient_bill_id, dependent: :nullify
  has_many :patient_visit_details, through: :primary_patient_visits	
  has_many :secondary_patient_visits, class_name: 'PatientVisit', foreign_key: :secondary_patient_bill_id, dependent: :nullify
end
