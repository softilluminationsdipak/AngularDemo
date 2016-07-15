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

  REPORT_TYPES = {
    :usage_summary    => "Usage Summary",
    :usage_by_patient => "Usage by Patient",
    :usage_by_doctor  => "Usage by Doctor",
    :list_short       => "List - Short",
    :list_full        => "List - Full"
  }
  ORDERS = {
    :name        => "Name",
    :code_type   => "Code Type",
    :description => "Description",
    :cpt_number  => "CPT Number"
  }

  ## Relationship
  belongs_to :clinic
  belongs_to :account

	has_many :patient_visit_details, dependent: :destroy
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

  def type
    AppConfig["options"]["code_types"].invert[type_code]
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

  def rendered
    patient_visit_details.collect(&:amount_cents).sum
  end

  def adjusted
    0
  end

  def paid
    patient_visit_details.collect{|pvd| pvd.incoming_payments.collect(&:amount_cents).sum }.sum
  end

  def default_fee(patient_case=nil)
    return nil unless is_service?    
    if patient_case.nil?
    	procedure_codes_fee_schedule_labels.try(:first)
    else
    	procedure_codes_fee_schedule_labels.where('fee_schedule_label_id = ?', patient_case.fee_schedule_label_id).try(:last)
    end
  end

  def self.usage_summary(account)
    data = {}
    
    account.procedure_codes.each do |procedure_code|
      data[procedure_code.type_code] ||= []
      data[procedure_code.type_code] << [
        procedure_code.name,
        procedure_code.description,
        procedure_code.cpt_code,
        procedure_code.rendered,
        procedure_code.patient_visit_details.count,
        procedure_code.paid,
        procedure_code.adjusted
      ]
    end
    
    lines = []
    
    data.each do |codes|
      totals = [
        {:colspan => 3, :content => "Subtotals"},
        codes[1].map { |d| d[3] }.compact.sum,
        codes[1].map { |d| d[4] }.compact.sum ,
        {:colspan => 2, :content => ""}
      ]
      
      codes[1].each do |code|
        code[3] = code[3] unless code[3].nil?
        lines << code
      end
      
      lines << totals
    end
    
    lines
  end

  def self.usage_by_patient(account, params)
    data = []
		from_date = params[:from_date_value].present? ? params[:from_date_value] : (Time.zone.now - 7.day).to_date
		todate 		= params[:to_date_value].present? ? params[:to_date_value] : (Time.zone.now).to_date
		p = account.procedure_codes.select("procedure_codes.name AS procedure_code_name, procedure_codes.description AS procedure_code_description, CONCAT(contacts.first_name,' ',contacts.last_name) AS patient_name, patients.account_code AS account_code, CONCAT(contacts_providers.first_name,' ',contacts_providers.last_name) AS provider_name, SUM(patient_visit_details.amount_cents) AS amount_cents, patient_visits.visited_at").joins(:patient_visit_details => {:patient_visit => {:patient_case => { :patient => :contact, :provider => :contact}}}).group('procedure_codes.name, patient_visits.id, procedure_codes.description, contacts.first_name, contacts.last_name, patients.account_code, contacts_providers.first_name, contacts_providers.last_name, procedure_codes.id').where('DATE(patient_visits.visited_at) >= ? AND DATE(patient_visits.visited_at) <= ?', from_date.to_date, todate.to_date)
    
    usage_count = 0
    total_amount = 0
    
    p.each_with_index do |code, i|
      if i > 0
        new_procedure = (code.procedure_code_name != p[i-1].procedure_code_name)
      else
        new_procedure = false
      end
      
      if new_procedure
        data, usage_count, total_amount = usage_by_patient_subtotals(p, data, i, usage_count, total_amount)
        
        data << [{
            :colspan => 5, 
            :content => "#{code.procedure_code_name} - #{code.procedure_code_description}", 
            :font_style => :bold
        }]
      end
      
      amount_cents = code.amount_cents.to_i
      
      new_patient = (i == 0 || p[i].procedure_code_name != p[i-1].procedure_code_name)
      data << [
        (new_patient || new_procedure) ? code.account_code : "",
        code.visited_at.to_date,
        amount_cents,
        (new_patient || new_procedure) ? code.provider_name : "",
        (new_patient || new_procedure) ? code.patient_name : ""
      ]
      
      usage_count += 1
      total_amount += amount_cents
      
      if i == (p.size - 1)
        data, usage_count, total_amount = ProcedureCode.usage_by_patient_subtotals(p, data, i, usage_count, total_amount)
      end
    end

    data
  end

  def self.short_list(account, params)
    data = []    
    account.procedure_codes.each do |procedure_code|
      default_fee = procedure_code.default_fee
      fee = (default_fee.nil? || default_fee.fee_in_dollars.nil? ? 0 : default_fee.fee_in_dollars)
            
      data << [
        procedure_code.name,
        procedure_code.cpt_code,
        procedure_code.description,
        fee,
        procedure_code.type,
        procedure_code.modifier.to_s
      ]
    end
    data
  end

  def self.usage_by_doctor(account, params)
    data 		= []
		d_from 	= params[:from_date_value].present? ? params[:from_date_value] : (Time.zone.now - 7.day).to_date
		d_to 		= params[:to_date_value].present? ? params[:to_date_value] : (Time.zone.now).to_date
		p 			= account.procedure_codes.select('providers.id, procedure_codes.name,providers.signature_name AS doc,procedure_codes.name AS proc_name,patient_visits.visited_at AS date,COUNT(patient_visit_details.id) AS cnt,SUM(patient_visit_details.amount_cents) AS amount,0 AS paid_amount, 0 AS adjusted').joins(:patient_visit_details => [:provider, :patient_visit]).group('providers.id, procedure_codes.name, patient_visits.visited_at').order('providers.signature_name ASC, procedure_codes.name ASC, patient_visits.visited_at ASC').where('DATE(patient_visits.visited_at) >= ? AND DATE(patient_visits.visited_at) <= ?', d_from.to_date, d_to.to_date)
    
    usage_count 		= 0
    total_amount 		= 0
    total_paid 			= 0
    total_adjusted 	= 0
    
    p.each_with_index do |code, i|
      
      new_procedure = (i == 0 || p[i].proc_name != p[i-1].proc_name)
      
      if i != 0 && new_procedure
        data, usage_count, total_amount, total_paid, total_adjusted = 
          ProcedureCode.usage_by_doctor_subtotals(p, data, i, usage_count, total_amount, total_paid, total_adjusted)
      end
      
      amount_in_dollars 	= code.amount.to_i.to_s
      paid_in_dollars 		= code.paid_amount.to_i.to_s
      adjusted_in_dollars = code.adjusted.to_i.to_s
      
      data << [
        (new_procedure ? code.doc : ""),
        (new_procedure ? code.proc_name : ""),
        code.date.to_date.to_s,
        code.cnt.to_s,
        amount_in_dollars,
        paid_in_dollars,
        adjusted_in_dollars
      ]
      
      usage_count += 1
      total_amount += amount_in_dollars.to_i
      total_paid += paid_in_dollars.to_i
      total_adjusted += adjusted_in_dollars.to_i
      
      if i == (p.size - 1)
        data, usage_count, total_amount, total_paid, total_adjusted = 
          ProcedureCode.usage_by_doctor_subtotals(p, data, i, usage_count, total_amount, total_paid, total_adjusted)
      end
    end
    
    data
  end

  def self.full_list(account, params)
    data = []
    fees = {}
    
    account.procedure_codes.each do |procedure_code|
      data << [
        procedure_code.name,
        procedure_code.cpt_code,
        procedure_code.description,
        procedure_code.type,
        procedure_code.modifier
      ]
      
      fees[procedure_code.name] ||= []
      
      procedure_code.procedure_codes_fee_schedule_labels.fee_cents_gt(0).each do |lbl|
        fees[procedure_code.name] << [
          lbl.fee_schedule_label.label,
          lbl.fee_in_dollars,
          lbl.is_percentage ? "%" : "No",
          lbl.copay,
          lbl.expected_insurance_payment_in_dollars
        ]
      end
    end
    
    return data, fees
  end

  private

  def self.usage_by_patient_subtotals(p, data, i, usage_count, total_amount)
    data << [
      {:colspan => 2, :content => "Subtotal", :align => :right},
      total_amount,
      {:colspan => 2, :content => p[i-1].provider_name, :align => :left}
    ]
    
    data << [
      {:colspan => 2, :content => "#{usage_count} Total", :align => :right},
      total_amount,
      {
        :colspan => 2, 
        :content => "#{p[i-1].procedure_code_name} - #{p[i-1].procedure_code_description}", 
        :font_style => :bold, :align => :left
      }
    ]
    
    usage_count = 0
    total_amount = 0
    
    return data, usage_count, total_amount
  end

  def self.usage_by_doctor_subtotals(p, data, i, usage_count, total_amount, total_paid, total_adjusted)
    data << [
      {colspan: 2, content: ""},
      {content: "Subtotal:"},
      {content: usage_count.to_s},
      {content: total_amount.to_s},
      {content: total_paid.to_s},
      {content: total_adjusted.to_s}      
    ]
    
    usage_count = 0
    total_amount = total_paid = total_adjusted = 0
    
    return data, usage_count, total_amount, total_paid, total_adjusted
  end
  
end
