require 'csv'
class ProcedureCode < ActiveRecord::Base
	
	include ActionView::Helpers::TextHelper
	acts_as_paranoid

	extend FriendlyId
  friendly_id :name, use: :slugged

  TYPES = [
    ['Ins Billable Procedure',     6],
    ['Non-Ins Billable Procedure', 7],
    ['Patient Payment',            2],
    ['Insurance Payment',          0],
    ['Patient Adjustment',         3],
    ['Insurance Adjustment',       1],
    ['Reserved',                   5]
  ]

  TYPES_OF_SERVICES = [
    ['Medical',      3],
    ['P.T.',         1],
    ['Chiropractic', 0],
    ['Radiology',    2],
    ['Surgery',      4],
    ['Maternity',    7],
    ['Ambulance',    6]
  ]

  ADJUSTMENT_TYPES 			= [1, 3]
  INSURANCE_TYPES  			= [0]
  PAYMENT_TYPES    			= [0, 2]
  PATIENT_PAYMENT_TYPES = [2]
  SERVICE_TYPES    			= [6, 7]

  SALES_TAX_PROCEDURE_CODE_NAME 					= 'SalesTax'
  INSURANCE_WO_PROCEDURE_CODE_NAME 				= 'WOI'
  INSURANCE_PAYMENT_PROCEDURE_CODE_NAME 	= 'IN'
  PATIENT_ADJUSTMENT_PROCEDURE_CODE_NAME 	= 'ADJ'

  ## Relationship
  belongs_to :clinic
  belongs_to :account

  has_many :procedure_codes_fee_schedule_labels, dependent: :destroy
  accepts_nested_attributes_for :procedure_codes_fee_schedule_labels, reject_if: proc { |attributes| attributes['fee_cents'].blank? }

  scope :alphabetically, -> (order) { order("#{order || 'name'}  ASC") }
  scope :ascend_by_name, -> { order("name ASC")}
  scope :descend_by_name, -> { order("name DESC")}

	## Validations
	validates :name, :description, presence: true
	validates :cpt_code, presence: true, if: :is_service?

	## Methods

  def is_service?
    SERVICE_TYPES.include?(type_code)
  end
	
  def is_payment?
    PAYMENT_TYPES.include?(type_code)
  end

  def can_have_fee_schedules?
    type_code.nil? || is_service?
  end

  def preload_existing_fee_schedules
    clinic.account.fee_schedule_labels.each do |fee_schedule_label|
      unless procedure_codes_fee_schedule_labels.exists?(fee_schedule_label_id: fee_schedule_label.id)
        if new_record?
          procedure_codes_fee_schedule_labels.build(fee_schedule_label: fee_schedule_label)
        else
          procedure_codes_fee_schedule_labels.create(fee_schedule_label: fee_schedule_label)
        end
      end
    end
  end
			
  def type_code_name
    name = {}
    TYPES.each{|t| name.merge!(t[1] => t[0])}
    if type_code.present?
      return name[type_code]
    else
      return 'Undefine'
    end
  end

  def service_type_code_name
    name = {}
    TYPES_OF_SERVICES.each{|t| name.merge!(t[1] => t[0])}
    if service_type_code.present?
      return name[service_type_code]
    else
      return 'Undefine'
    end
  end

  def is_adjustment?
    ADJUSTMENT_TYPES.include?(type_code)
  end

  def is_insurance_billable?
    type_code == 6
  end

  def is_payment?
    PAYMENT_TYPES.include?(type_code)
  end

  def is_insurance_payment?
    INSURANCE_TYPES.include?(type_code)
  end

  def is_patient_payment?
    PATIENT_PAYMENT_TYPES.include?(type_code)
  end

  def non_insurance_billable?
    type_code == 7
  end

  def truncated_title
    "#{name} : " << truncate(description, length: 25)
  end

  def title
    "#{name} (#{cpt_code})"
  end
  alias :title_name :title

  def is_adjustment?
    ADJUSTMENT_TYPES.include?(type_code)
  end
  
  def is_patient_adjustment?
    3 == type_code
  end

  def is_insurance_adjustment?
    1 == type_code
  end

end
