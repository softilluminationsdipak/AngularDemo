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

  has_many :patient_cases, as: :referrer

  ## Validations
  validates :source, presence: true, uniqueness: {scope: :account_id}

  ## Scopes
  scope :alphabetically, -> { includes(:contact).order('contacts.last_name ASC, contacts.first_name')}
  scope :active, -> {where(is_active: true)}
  scope :inactive, -> {where(is_active: false)}
  
  ## Methods
  def self.referrers_list(clinic, account) ## Used in patient_case edit and new form page.
    list = []

    clinic.patients.each do |p|
      list << [p.last_name_first, 'patient_' + p.id.to_s] if p.clinic_id == clinic.id
    end

    account.referrers.each do |r|
      list << [r.title, 'referrer_' + r.id.to_s]
    end

    list.sort{ |a, b| (a.first || '').downcase <=> (b.first || '').downcase}
  end   

  
end
