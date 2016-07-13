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

  def total_charge
    0
  end

  def total_paid
    0
  end

  def outstanding
    0
  end

  def collectn
    0
  end

  def billable_visits
    billable_visits = []

    self.patient_visits.unbilled.each do |unbilled_visit|
      if unbilled_visit.billable?
        billable_visits << unbilled_visit
      end
    end
    billable_visits
  end

  def billable_visits?
    billable_visits.length > 0
  end

	def total_patient_owes
    patient_visits.inject(0) { |sum, v| sum + v.total_patient_owes }
  end

  def total_patient_owes_in_dollars
    total_patient_owes
  end

  def create_bills(account_id)
  	bills 			= []
  	return bills unless primary_insurance_carrier_id?
  	
  	bill_count 	= 0
  	visits_pool = []
  	i 					= 0

  	billable_visits_tmp = billable_visits
  	c 									= billable_visits_tmp.length

  	while i < c
  		v 					= billable_visits_tmp[i]
  		bill_count += v.billable_details.length

  		visits_pool << v

      if (i != (c - 1)) && ((bill_count + billable_visits_tmp[i + 1].billable_details.length) <= 6)
        i += 1
        next
      end
			
			if bill_count >= 6 || i == (c - 1)
				bills << PatientBill.create(patient_case_id: id,
                                    insurance_carrier_id: primary_insurance_carrier_id,
                                    is_secondary_claim: false,
                                    account_id: account_id, 
                                    hcfa_bill_date: Date.current,
                                    status_code: 0,
                                    is_workmanscomp_progress_form: false,
                                    is_assigned: false,
                                    provider: provider)

        visits_pool.each do |vp|
          vp.update_attribute(:primary_patient_bill_id, bills.last.id)
        end

        visits_pool = []
        bill_count = 0
			end
			i += 1
  	end
  	bills
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
