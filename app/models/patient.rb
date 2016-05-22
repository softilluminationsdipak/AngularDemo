class Patient < ActiveRecord::Base
	## Slug
  extend FriendlyId
  friendly_id :full_name, use: :slugged

	include Contactable
  include Addressable
	include Referrerable

	acts_as_paranoid
  acts_as_contactable
  alias :name :full_name
  
  acts_as_addressable
  acts_as_referrerable

  ## Relationship
  attr_accessor :ssn
  
	belongs_to :clinic

	has_many :referred_patients, :class_name => 'Patient', :as => :referrer

	belongs_to :employer_contact, :class_name => 'Contact'
	accepts_nested_attributes_for :employer_contact

	belongs_to :employer_address, :class_name => 'Address'
	accepts_nested_attributes_for :employer_address

	## Validations
	validate :contact_last_name_blank, :contact_sex_blank
	validates :overdue_fee_percentage, numericality: { greater_than: 0}, allow_blank: true
	validates :ssn, format: { with: /(\d{3}[-]?\d{2}[-]?\d{4}$)/, message: "should be in the following format: XXX-XX-XXXX" }, allow_blank: true

	## Callbacks
	before_save :assign_employer_addressable

	## Scopes
	scope :active, -> { where( is_active: true ) }
	scope :inactive, -> { where( is_active: false ) }
	scope :alphabetically, -> { includes(:contact).order('contacts.last_name ASC, contacts.first_name ASC')}

	## Callback Methods
	def assign_employer_addressable
		employer_address.addressable = employer_contact
	end

	## Instance Methods
	def title
		contact.name
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
   
end
