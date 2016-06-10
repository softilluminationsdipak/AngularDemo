class Attorney < ActiveRecord::Base

  extend FriendlyId
  friendly_id :attorney_name, use: :slugged

  include Contactable
  include Addressable

  acts_as_contactable
  alias :attorney :full_name
  alias :name     :full_name
  
  acts_as_addressable
  acts_as_paranoid

	## Relationships
	belongs_to :account
  
	belongs_to :insurance_carrier
	accepts_nested_attributes_for :insurance_carrier

  has_many :patient_cases
  
  ## Callbacks
  before_create :default_value

	## Validations
  validate :contact_company_name_blank
  validates :attorney_name, presence: true, uniqueness: {scope: :account_id}

	## Scopes
  scope :ascend_by_your_code, -> { order('contacts.company_name ASC')}
  scope :ascend_by_company, -> { order('contacts.company_name ASC')}
  scope :ascend_by_zip, -> { order('addresses.zip ASC')}

  def default_value
    self.contact.first_name = "A New"
    self.contact.last_name = "Attorney"
    self.contact.company_name = "A New Attorney Company"
  end
  
  def attorney=(name)
    names = name.split(" ")
    self.contact.first_name = names.first
    self.contact.last_name = names[1..names.size].join(" ")
  end
end
