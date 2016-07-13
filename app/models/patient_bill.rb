class PatientBill < ActiveRecord::Base
	acts_as_paranoid

	## Relationship
	belongs_to :patient_case
	belongs_to :insurance_carrier
	belongs_to :provider
	belongs_to :account

	has_many :primary_patient_visits, class_name: 'PatientVisit', foreign_key: :primary_patient_bill_id, dependent: :nullify
  has_many :patient_visit_details, through: :primary_patient_visits	
  has_many :secondary_patient_visits, class_name: 'PatientVisit', foreign_key: :secondary_patient_bill_id, dependent: :nullify

  def hcfa_data
    data 					= []
    hcfa_details 	= []

    primary_patient_visits.each do |ppv|
      ppv.billable_details.each do |ppv_vd|
        hcfa_details << ppv_vd                                                    
                                                                                  
        if hcfa_details.length >= 6                                               
          data << hcfa_data_with_details(hcfa_details, hcfa_details[0].provider)  
          hcfa_details = []                                                       
        end                                                                       
      end
    end

    if hcfa_details.length < 6 && hcfa_details.length > 0
      data << hcfa_data_with_details(hcfa_details, hcfa_details[0].provider)
    end

   	data
  end

  def hcfa_data_with_details(details, provider)
  	clinic 		= patient_case.patient.clinic
  	visit_ids = details.collect(&:patient_visit_id).uniq
  	visit 		= PatientVisit.find(visit_ids[0])
  	data 			= {}
  	
  end

end
