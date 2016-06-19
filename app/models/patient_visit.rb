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

end
