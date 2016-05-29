class Attorney < ActiveRecord::Base

  extend FriendlyId
  friendly_id :name, use: :slugged

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

	## Validations
  validate :contact_company_name_blank
  validate :unique_name

	## Scopes
  scope :ascend_by_your_code, -> { order('contacts.company_name ASC')}
  scope :ascend_by_company, -> { order('contacts.company_name ASC')}
  scope :ascend_by_zip, -> { order('addresses.zip ASC')}

  def unique_name
    if contact.contactable_id.present?
      contact = Contact.where('contactable_type = ? and company_name = ? and first_name = ? and last_name = ? and contactable_id = ?', self.class.name, self.contact.company_name, self.contact.first_name, self.contact.last_name, self.contact.contactable_id).try(:first)
    else
      contact = Contact.where('contactable_type = ? and company_name = ? and first_name = ? and last_name = ?', self.class.name, self.contact.company_name, self.contact.first_name, self.contact.last_name).try(:first)
    end
  
    errors.add(:attorney, "name already has been taken") if contact.present?
  end

end
