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

  def self.get_attorney_report_data(attorneys_report, current_account)  
    order_of  = "ascend_by_#{attorneys_report[:order]}"
    data      = []
    if attorneys_report[:type] == 'collection_percent'
      attornes = current_account.attorneys.includes([:contact, :address]).where("contacts.id >= '#{attorneys_report[:range_from]}' and contacts.id <= '#{attorneys_report[:range_to]}'").references([:contact, :address]).send(order_of.to_sym)
      attornes.each do |attorney|
        if attorney.patient_cases.any?
          data << {
            attorney: {
              code: attorney.try(:insurance_carrier).try(:name),
              company: attorney.contact.company_name,
              comments: attorney.notes || "",
            },
            patient_cases: []
          }
          attorney.patient_cases.each do |patient_case|
            patient = patient_case.patient
            data[-1][:patient_cases] << {
              patient: patient.full_name,
              case: patient_case.description,
              total_charge: patient_case.total_charge,
              total_paid: patient_case.total_paid,
              outstanding: patient_case.outstanding,
              collectn: patient_case.collectn,
            }            
          end
        end
      end
    else
      attornes = current_account.attorneys.includes([:contact, :address]).where("contacts.id >= '#{attorneys_report[:range_from]}' and contacts.id <= '#{attorneys_report[:range_to]}'").references([:contact, :address]).send(order_of.to_sym)
      attornes.each do |attorney|
        data << [
          attorney.insurance_carrier.nil? ? "" : attorney.insurance_carrier.alias_name,
          attorney.contact.company_name,
          attorney.address.one_liner,
          attorney.contact.phone1,
          attorney.contact.attention,
          attorney.notes
        ]        
      end
    end
    data
  end
end
