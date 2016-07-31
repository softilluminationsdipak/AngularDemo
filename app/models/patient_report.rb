class PatientReport < Report
	REPORT_TYPES = { 
		all_patients: "All Patients", 
    financial: "Financial", 
    birthdays: "Birthdays", 
    new_patients: "New Patients", 
    last_visit: "Last Visit", 
    last_x_ray: "Last X-Ray",
    patients_attorneys: "Patient's Attorneys",
    patients_insurance_carriers: "Patient's Insurance Carriers",
    authorized_through: "Authorized Through",
    letters: "Letters"
  }
  
  SORT_BY = { 
  	name: "Name", 
  	account: "Account", 
  	zip_code: "Zip Code", 
  	date: "Date",
    category: "Category", 
    type: "Type", 
    primary_carrier: "Primary Carrier",
    insurance_type: "Insurance Type", 
    doctor: "Doctor", 
    amount_owed: "Amount Owed",
    visit_count: "Visit Count", 
    date: "Date", 
    employer: "Employer", 
    referral: "Referral"
  }

  def self.all_patients(account)
    data = []
    account.patients.each do |patient|
      data << [
        patient.account_code,
        patient.name_with_activity_flag,
        patient.appt.nil? ? "" : patient.appt.date.to_date  ,
        patient.last_visit.try(:visited_at).try(:to_date),
        patient.contact.phone1,
        patient.contact.phone2,
        patient.is_active ? "no" : "yes"
      ]
    end
    data  
  end

  def self.financial(account)
    data = []
    
    account.patients.each do |patient|
      data << [
        patient.account_code,
        patient.name_with_activity_flag,
        patient.last_ov_date(account).to_s,
        patient.last_pay_date(account).to_s,
        patient.statement_date.to_s,
        patient.balance_in_dollars,
        patient.insurance_owes_in_dollars,
        patient.patient_owes_in_dollars
      ]
    end    
    data
  end

end