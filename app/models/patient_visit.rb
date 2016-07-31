class PatientVisit < ActiveRecord::Base
	## Relationship
	belongs_to :patient_case
  
  #belongs_to :primary_patient_bill, class_name: 'PatientBill'
  #belongs_to :secondary_patient_bill, class_name: 'PatientBill'
  #belongs_to :attorney_patient_bill, class_name: 'PatientBill'
  
  belongs_to :diagnosis1, class_name: 'DiagnosisCode'
  belongs_to :diagnosis2, class_name: 'DiagnosisCode'
  belongs_to :diagnosis3, class_name: 'DiagnosisCode'
  belongs_to :diagnosis4, class_name: 'DiagnosisCode'

  has_many :patient_visit_details, dependent: :destroy

  ## Scopes
  scope :descend_by_visited_at, -> { order("visited_at DESC")}
  scope :unbilled, -> { where('primary_patient_bill_id IS NULL and should_bill_primary = ?', true)}
  
  ## Methods
  def pull_diagnosis_and_dates_from_case(pcase_id = nil)
    pcase_id ||= patient_case_id
    pc         = PatientCase.find_by(id: pcase_id)

    self.diagnosis1_id = pc.diagnosis1_id
    self.diagnosis2_id = pc.diagnosis2_id
    self.diagnosis3_id = pc.diagnosis3_id
    self.diagnosis4_id = pc.diagnosis4_id

    self.diagnosis1_description = pc.diagnosis1_description
    self.diagnosis2_description = pc.diagnosis2_description
    self.diagnosis3_description = pc.diagnosis3_description
    self.diagnosis4_description = pc.diagnosis4_description

    self.onset_at         = pc.onset_at
    self.first_treated_at = pc.first_treated_at    
  end

  def total_service(scope_options = nil)
    if scope_options
      patient_visit_details.where(scope_options).collect{ |d| d.service * d.units_sold if d.service }.compact.sum
    else
      patient_visit_details.collect{ |d| (d.service.present? ? d.service : 0) * (d.units_sold.present? ? d.units_sold : 0) if d.service }.compact.sum
    end
  end

  def total_paid(scope_options = nil)
    if scope_options
      patient_visit_details.where(scope_options).collect{ |d| d.paid * d.units_sold if d.paid }.compact.sum
    else
      patient_visit_details.collect{ |d| (d.paid.present? ? d.paid : 0) * (d.units_sold.present? ? d.units_sold : 0) if d.paid }.compact.sum
    end
  end

  def total_adjust(scope_options = nil)
    if scope_options
      patient_visit_details.where(scope_options).collect{ |d| d.adjust * d.units_sold if d.adjust }.compact.sum
    else
      patient_visit_details.collect{ |d| d.adjust * (d.units_sold.present? ? d.units_sold : 0) if d.adjust.present? }.compact.sum
    end
  end    

  def patient_owes_reduced
    patient_visit_details.collect{|vd| vd.patient_owes_reduced}.compact.sum
  end
  alias :total_patient_owes :patient_owes_reduced

  def insurance_owes_reduced
    patient_visit_details.collect{|vd| vd.insurance_owes_reduced}.compact.sum
  end
  alias :total_insurance_owes :insurance_owes_reduced 
  
  def balance_in_cents
    patient_case.patient_visits.descend_by_visited_at.where("visited_at <= ?", visited_at).collect{ |vd| vd.patient_owes_reduced + vd.insurance_owes_reduced }.compact.sum
  end

  def balance_in_dollars
    self.balance_in_cents
  end

  def foreign_visit_incoming_payments
    payments = []
    patient_visit_details.each do |v|
      v.incoming_payments.each do |p|
        if p.source_patient_visit_detail.patient_visit_id != self.id
          payments << p
        end
      end
    end
    payments
  end

  def can_delete?
    foreign_visit_incoming_payments.empty?
  end

  def pull_from_case
    update_attributes({
      diagnosis1_id:  patient_case.diagnosis1_id,
      diagnosis2_id: patient_case.diagnosis2_id,
      diagnosis3_id: patient_case.diagnosis3_id,
      diagnosis4_id: patient_case.diagnosis4_id,
      diagnosis1_description: patient_case.diagnosis1_description,
      diagnosis2_description: patient_case.diagnosis2_description,
      diagnosis3_description: patient_case.diagnosis3_description,
      diagnosis4_description: patient_case.diagnosis4_description,
      onset_at: patient_case.onset_at,
      first_treated_at: patient_case.first_treated_at,
    })
  end

  def push_to_case
    patient_case.update_attributes({
      diagnosis1_id: diagnosis1_id,
      diagnosis2_id: diagnosis2_id,
      diagnosis3_id: diagnosis3_id,
      diagnosis4_id: diagnosis4_id,
      diagnosis1_description: diagnosis1_description,
      diagnosis2_description: diagnosis2_description,
      diagnosis3_description: diagnosis3_description,
      diagnosis4_description: diagnosis4_description,
      onset_at: onset_at,
      first_treated_at: first_treated_at,
    })
  end

  def billable_details
    billable_details = []

    patient_visit_details.each do |vd|
      if vd.procedure_code.is_insurance_billable?
        billable_details << vd
      end
    end

    billable_details
  end

  def billable?
    billable_details.length > 0
  end

  def is_payment?
    patient_visit_details.any?
  end

  def is_insurance_billable?
    patient_visit_details.any?
  end

  def provider
    detail_with_provider = self.patient_visit_details.where('provider_id IS NOT NULL').try(:first)
    detail_with_provider.provider if detail_with_provider
  end

  def self.report(visit_id, params)
    only_print_services = params[:only_print_services]
    only_print_payments = params[:only_print_payments]
    on_receipt          = params[:on_receipt]
    dont_print_diagnoses_or_tax_id  = params[:dont_print_diagnoses_or_tax_id]
    dont_print_visit_pat_owes       = params[:dont_print_visit_pat_owes]
    dont_print_case_balances        = params[:dont_print_case_balances]

    data          = []
    patient_visit = PatientVisit.find(visit_id)

    patient_visit.patient_visit_details.each do |vd|
      next if only_print_services == "1" && !vd.procedure_code.is_service?
      next if only_print_payments == "1" && !vd.procedure_code.is_payment?

      data << {
        description: vd.procedure_code.description,
        cpt_code: vd.is_service? ? vd.procedure_code.cpt_code : "",
        unit: vd.is_service? ? vd.units_sold : "",
        service: vd.is_service? ? vd.service : "",
        paid: vd.is_payment? ? vd.paid : "",
        adjust: vd.is_adjustment? ? vd.adjust : "",
        balance: vd.balance_cents
      }      
    end

    data << {
      description: "Visit Totals",
      cpt_code: nil,
      unit: nil,
      service: data.reject{ |d| d[:service] == "" }.sum { |d| d[:service] },
      paid: data.reject{ |d| d[:paid] == "" }.sum { |d| d[:paid] },
      adjust: data.reject{ |d| d[:adjust] == "" }.sum { |d| d[:adjust] },
      balance: data.reject{ |d| d[:balance] == "" }.sum { |d| d[:balance] },
    }

    fees = {
      title: on_receipt == "doctor" ? patient_visit.provider.try(:address_stamp).to_s : patient_visit.patient_case.patient.clinic.address_stamp.to_s,
      title2: patient_visit.patient_case.patient.address_stamp,
      date: patient_visit.visited_at.to_date.to_s,
      onset: "Onset: " + (patient_visit.onset_at.nil? ? "" : patient_visit.onset_at.to_date.to_s),
      first_treatment: "1st Treatment: " + (patient_visit.first_treated_at.blank? ? "" : patient_visit.first_treated_at.to_date.to_s),
      account_patient_owes: "Account Patient Owes: " + patient_visit.patient_case.total_patient_owes_in_dollars.to_s,
      diagnosis1: patient_visit.diagnosis1.blank? ? "" : (dont_print_diagnoses_or_tax_id == "0" ? patient_visit.diagnosis1.code + " " : "") +  patient_visit.diagnosis1.description.to_s,
      diagnosis2: patient_visit.diagnosis2.blank? ? "" : (dont_print_diagnoses_or_tax_id == "0" ? patient_visit.diagnosis2.code + " " : "") +  patient_visit.diagnosis2.description.to_s,
      diagnosis3: patient_visit.diagnosis3.blank? ? "" : (dont_print_diagnoses_or_tax_id == "0" ? patient_visit.diagnosis3.code + " " : "") +  patient_visit.diagnosis3.description.to_s,
      diagnosis4: patient_visit.diagnosis4.blank? ? "" : (dont_print_diagnoses_or_tax_id == "0" ? patient_visit.diagnosis4.code + " " : "") +  patient_visit.diagnosis4.description.to_s,
    }

    fees[:account_balance]    = "Account Balance: " + patient_visit.patient_case.balance_in_dollars.format.to_s if dont_print_case_balances == "0"
    fees[:visit_patient_owes] = "Visit Patient Owes: " + patient_visit.patient_owes_reduced_in_dollars.format.to_s if !dont_print_visit_pat_owes == "0"
    
    d = data.map do |a|
      el = []
      el << a[:description]
      el << a[:cpt_code]
      el << a[:unit]
      el << (a[:service] == "" ? "" : a[:service]).to_s
      el << (a[:paid] == "" ? "" : a[:paid]).to_s
      el << (a[:adjust] == "" ? "" : a[:adjust]).to_s
      el << (a[:balance] == "" ? "" : a[:balance]).to_s
      el
    end

    return d, fees
  end

  def insurance_owes_in_dollars
    total_insurance_owes
  end

  def patient_owes_in_dollars
    total_patient_owes
  end

end
