class Clinic < ActiveRecord::Base

	include Contactable
  include Addressable

  acts_as_contactable
  acts_as_addressable
  acts_as_paranoid

  extend FriendlyId
  friendly_id :title, use: :slugged

  ## Callbacks
  before_save :if_billing_address_same_as_service_address
  after_save :save_billing_addressable
  after_create :build_clinic_preference_if_nil

  ## Relationship
	belongs_to :account

	belongs_to :billing_address, class_name: 'Address'
	accepts_nested_attributes_for :billing_address

  has_one :clinic_preference, :dependent => :destroy
  accepts_nested_attributes_for :clinic_preference

  has_many :providers

  belongs_to :main_provider, class_name: 'Provider'
  
  has_many :patients, dependent: :destroy
  has_many :diagnosis_codes, dependent: :destroy
  has_many :procedure_codes, dependent: :destroy
  has_many :fee_schedule_labels, dependent: :destroy
  has_many :contacts, through: :patients
  has_many :appointments, dependent: :destroy
  
  ## Validation
  validates :account_id, presence: true
  validates_associated :address, message: nil
  validates_associated :contact, message: nil
  validates_associated :billing_address, message: nil
  
  ## Scopes
  scope :alphabetically, -> { includes(:contact).order('contacts.company_name ASC')}
  scope :latest, -> { order('created_at DESC')}
  
  ## Methods
  def title
    contact.company_name
  end
  alias :name :title

  def should_generate_new_friendly_id?
    contact.company_name_changed?
  end

  def self.build(configuration={})
    c = self.new(configuration)
    c.build_contact
    c.build_address
    c.build_billing_address
    return c
  end
  
  ## Callback Methods
  def if_billing_address_same_as_service_address
    return unless same_as_service_location == true
    self.build_billing_address unless self.billing_address.present?
    
    [ "street", "street2", "city", "state", "zipcode" ].each do |clone_attr|
      self.billing_address.send(clone_attr + "=", self.address.send(clone_attr))
      self.billing_address.addressable_id = id
      self.billing_address.addressable_type = Clinic
    end
  end

  def save_billing_addressable
    return unless same_as_service_location == false
    build_billing_address(addressable_id: id, addressable_type: Clinic)
  end

  def phone_number
    contact.present? && contact.phone1.present? ? contact.phone1 : 'Undefine'
  end

  def fax_number
    contact.present? && contact.fax1.present? ? contact.fax1 : 'Undefine'
  end

  def contact_email
    contact.present? && contact.email1.present? ? contact.email1 : 'Undefine'
  end

  def provider_name
    main_provider.present? ? main_provider.try(:signature_name) : 'Undefine'
  end

  def billing_office_address
    billing_address.present? ? billing_address.line1 : 'Undefine'
  end

  def billing_office_address_line2
    billing_address.present? ? billing_address.line2 : 'Undefine'
  end

  def billing_office_phone_number
    contact.present? && contact.phone2.present? ? contact.phone2 : 'Undefine'
  end

  def display_created_at
    created_at.strftime('%a, %d %b %Y - %H:%M %p')
  end

  def place_of_service
    clinic_preference ? clinic_preference.default_place_of_service : nil
  end

  def address_stamp
    address_stamp = []

    address_stamp << title
    address_stamp << address.line1
    address_stamp << address.line2
    address_stamp << contact.phone1

    address_stamp.compact.reject(&:blank?).join("\n")
  end
  private 

  def build_clinic_preference_if_nil
    self.create_clinic_preference if self.clinic_preference.nil?
  end

end
