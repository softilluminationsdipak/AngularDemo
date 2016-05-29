class Referrer < ActiveRecord::Base

  extend FriendlyId
  friendly_id :source, use: :slugged

	include Contactable
  include Addressable

  acts_as_contactable
  alias :name :full_name

  acts_as_addressable
  acts_as_paranoid

  ## Relationship
  belongs_to :insurance_carrier
  belongs_to :account

  ## Validations
  validates :source, presence: true, uniqueness: {scope: :account_id}

  ## Scopes
  scope :alphabetically, -> { includes(:contact).order('contacts.last_name ASC, contacts.first_name')}

end
