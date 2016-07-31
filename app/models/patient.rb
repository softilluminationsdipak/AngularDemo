class Patient < ActiveRecord::Base

	include Contactable
  include Addressable
	include Referrerable

	acts_as_paranoid
  acts_as_contactable
  alias :name :full_name
  
  acts_as_addressable
  acts_as_referrerable

  ## Relationship
  attr_accessor :ssn, :patient_name

  ## Slug
  extend FriendlyId
  friendly_id :name, use: :slugged
  
	belongs_to :clinic

	has_many :referred_patients, class_name: 'Patient', as: :referrer

	belongs_to :employer_contact, class_name: 'Contact'
	accepts_nested_attributes_for :employer_contact

	belongs_to :employer_address, class_name: 'Address'
	accepts_nested_attributes_for :employer_address

	has_many :family_members, class_name: 'Patient', foreign_key: 'parent_patient_id'
	
  has_many :patient_cases, dependent: :destroy
  has_many :patient_bills, through: :patient_cases
  has_many :patient_visits, :through => :patient_cases
  
  ## Validations
	validate :contact_last_name_blank, :contact_sex_blank
	validates :overdue_fee_percentage, numericality: { greater_than: 0}, allow_blank: true
	validates :ssn, format: { with: /(\d{3}[-]?\d{2}[-]?\d{4}$)/, message: "should be in the following format: XXX-XX-XXXX" }, allow_blank: true

	## Callbacks
	before_save :assign_employer_addressable
  before_save :set_slug_name

	## Scopes
	scope :active, -> { where( is_active: true ) }
	scope :inactive, -> { where( is_active: false ) }
	scope :alphabetically, -> { includes(:contact).order('contacts.last_name ASC, contacts.first_name ASC')}
  scope :with_contact, -> { where('patients.contact_id is NOT NULL') }

	## Callback Methods
	def assign_employer_addressable
		employer_address.addressable = employer_contact
	end

  def set_slug_name
    self.patient_name = self.title
  end

	## Instance Methods
  def current_case
    patient_cases.active.first
  end

	def title
		contact.name
	end

  def first_visit
    if current_case and current_case.patient_visits.any?
      current_case.patient_visits.first(:order => 'visited_at ASC')
    end
  end

  def last_visit
    if current_case and current_case.patient_visits.any?
      current_case.patient_visits.order('visited_at DESC').try(:first)
    end
  end

  def should_generate_new_friendly_id?
    contact.first_name_changed? || contact.last_name_changed?
  end

  def address_stamp
    address_stamp = []
    
    address_stamp << name
    address_stamp << address.line1
    address_stamp << address.line2
    address_stamp << contact.phone1
    
    address_stamp.compact.reject(&:blank?).join("\n")
  end

	def self.distinct_categories
	  Patient.active.map(&:category).uniq
	end

  def phone
    contact.try(:phone1) || contact.try(:phone2) || contact.try(:phone3)
  end

  def ssn
    encrypted_ssn
  end

  def active_text
    is_active ? 'active' : 'inactive'
  end

  def active_inverse_text
    !self.is_active ? 'active' : 'inactive'
  end
  
  def copy_details_from_patient(parent)
    if parent.present?
    	self.build_contact(contactable_type: 'Patient') unless self.contact.present?
    	self.build_address unless self.address.present?
    	self.build_employer_contact unless self.employer_contact.present?
    	self.build_employer_address unless self.employer_address.present?

      self.contact.last_name  		= parent.try(:contact).try(:last_name)
      self.contact.first_name 		= 'A Related'
      self.contact.sex 						= 'male'      
      self.contact.middle_initial = parent.try(:contact).try(:middle_initial)
      self.contact.phone1     = parent.try(:contact).try(:phone1)
      self.contact.phone2     = parent.try(:contact).try(:phone2)
      self.contact.phone3     = parent.try(:contact).try(:phone3)

      self.address.street   	= parent.try(:address).try(:street)
      self.address.street2  	= parent.try(:address).try(:street2)
      self.address.city     	= parent.try(:address).try(:city)
      self.address.state    	= parent.try(:address).try(:state)
      self.address.zipcode   	= parent.try(:address).try(:zipcode)

      self.clinic_id 					= parent.clinic_id      
      self.parent_patient_id 	= parent.parent_patient_id.blank? ? parent.id : parent.parent_patient_id
    end
    return self
  end

  def name_with_activity_flag
    (is_active ? "[v]" : "[ ]") + " " + name
  end

  def appt
    contact.appointments.order("date DESC").try(:first)
  end

  def first_visit
    if current_case and current_case.patient_visits.any?
      current_case.patient_visits.order('visited_at ASC').try(:first)
    end
  end
  
  def last_visit
    if current_case and current_case.patient_visits.any?
      current_case.patient_visits.order('visited_at DESC').try(:first)
    end
  end

  def last_ov_date(account)
    account.patient_visits.order("visited_at DESC").each do |patient_visit|
      return patient_visit.visited_at if patient_visit.is_insurance_billable?
    end
    return ""
  end

  def last_pay_date(account)
    account.patient_visits.order("visited_at DESC").each do |patient_visit|
      return patient_visit.visited_at if patient_visit.is_payment?
    end
    return ""
  end

  def statement_date
    Time.zone.now.strftime('%d/%m/%Y')
  end

  def balance_in_dollars
    0
  end

  def insurance_owes_in_dollars
    patient_visits.collect(&:insurance_owes_in_dollars).sum
  end
  
  def patient_owes_in_dollars
    patient_visits.collect(&:patient_owes_in_dollars).sum
  end

end
