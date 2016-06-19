class PatientCase < ActiveRecord::Base

  extend FriendlyId
  friendly_id :description, use: :slugged
	
	include Referrerable
	acts_as_referrerable

	acts_as_paranoid

	## Relationship
	belongs_to :patient
	belongs_to :provider
	belongs_to :attorney

	belongs_to :primary_insurance_carrier, class_name: 'InsuranceCarrier'
	belongs_to :secondary_insurance_carrier, class_name: 'InsuranceCarrier'

	belongs_to :primary_guarantor_contact, class_name: 'Contact'
	belongs_to :secondary_guarantor_contact, class_name: 'Contact'

	has_one :primary_guarantor, through: :primary_guarantor_contact, class_name: 'Patient', source: :contactable,  source_type: "Patient"
	has_one :secondary_guarantor, through: :secondary_guarantor_contact, class_name: 'Patient', source: :contactable, source_type: "Patient"

  belongs_to :diagnosis1, class_name: 'DiagnosisCode'
  belongs_to :diagnosis2, class_name: 'DiagnosisCode'
  belongs_to :diagnosis3, class_name: 'DiagnosisCode'
  belongs_to :diagnosis4, class_name: 'DiagnosisCode'

  belongs_to :fee_schedule_label
	
	has_many :patient_visits, dependent: :destroy 
	has_many :patient_bills
	
  ## Validations
	validates :disability_percentage, numericality: { greater_than: 0}, allow_blank: true
	validates :patient_id, :provider_id, :description, presence: true
	validate :validate_proper_guarantor_if_relationship_is_self

	## Scopes
	scope :latest, -> { order('created_at DESC')}  
	scope :active, -> {where(is_active: true)}
  scope :inactive, -> {where(is_active: false)}

	## Methods
	def diagnosis_codes_map
		codes = {}
		(1..4).to_a.each do |n|
			d = self.send("diagnosis#{n}".to_sym)
			if d
				my_description 	= self.send("diagnosis#{n}_description".to_sym).strip
				d.description 	= my_description unless my_description.nil? or my_description.empty?
				d.readonly!
				codes[d.id] 		= d
			end
		end
		codes
	end

	def display_created_at
		created_at.strftime('%d/%m/%Y')
	end

	def title
    search_title
  end

	def search_title
		"#{patient.full_name} - #{patient.last_visit.visited_at.to_date if patient.last_visit} - #{description} - #{patient_id}"
	end

	private

	def validate_proper_guarantor_if_relationship_is_self    
    if relationship_to_primary_guarantor == "self" && primary_guarantor_contact_id != patient.contact_id
      errors.add(:primary_guarantor_contact_id, "should be the patient.")
    end
    if relationship_to_secondary_guarantor == "self" && secondary_guarantor_contact_id != patient.contact_id
      errors.add(:secondary_guarantor_contact_id, "should be the patient.")
    end
	end

end
