class Contact < ActiveRecord::Base
  extend FriendlyId
  friendly_id :company_name, use: :slugged

  ## Relationships
  belongs_to :contactable, polymorphic: true
  has_many :appointments
  has_many :primary_guaranted_patient_cases, -> {where('patient_cases.primary_guarantor_contact_id != ?', id)}, foreign_key: :primary_guarantor_contact_id, class_name: "PatientCase" 
  has_many :secondary_guaranted_patient_cases, -> {where('patient_cases.primary_guarantor_contact_id != ?', id)}, foreign_key: :secondary_guarantor_contact_id, class_name: "PatientCase"

  ## Validations
  validates :email1, :email2, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, message: 'should be valid email address'}, allow_blank: true

  ## Scopes
  scope :patients, -> { where('contactable_type = ?', 'Patient')}
  scope :alphabetically, -> { order('last_name, first_name')}
  
	## Methods
	def full_name
		[first_name, middle_initial, last_name].compact.join(' ')
	end
	alias :name :full_name

	def last_name_first
    [last_name, [first_name, middle_initial].compact.join(" ")].compact.join(', ')
  end  

  def phone_number
  	phone1 || phone2 || phone3
  end
    
  def slugname
    company_name
  end
end
