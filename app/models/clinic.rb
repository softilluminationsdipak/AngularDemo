class Clinic < ActiveRecord::Base
	include Contactable
  include Addressable

  acts_as_contactable
  acts_as_addressable

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

  ## Validation
  validates :account_id, presence: true
  validates_associated :address, message: nil
  validates_associated :contact, message: nil
  validates_associated :billing_address, message: nil
  
  ## Scopes
  scope :alphabetically, -> { includes(:contact).order('contacts.company_name ASC')}
  
  ## Methods
  def title
    contact.company_name
  end
  alias :name :title

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
    [ "street", "street2", "city", "state", "zipcode" ].each do |clone_attr|
      self.billing_address.send(clone_attr + "=", self.address.send(clone_attr))
    end
  end

  def save_billing_addressable
    build_billing_address.addressable = contact
  end

  private 

  def build_clinic_preference_if_nil
    self.create_clinic_preference if self.clinic_preference.nil?
  end

end
