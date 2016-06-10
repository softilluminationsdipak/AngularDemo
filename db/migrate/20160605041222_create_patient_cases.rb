class CreatePatientCases < ActiveRecord::Migration
  def change
    create_table :patient_cases do |t|
    	t.string 		:slug
      t.integer 	:patient_id
	    t.integer 	:provider_id
	    t.string  	:description
	    t.integer 	:referrer_id
	    t.integer 	:attorney_id
	    t.integer 	:primary_insurance_carrier_id
	    t.integer 	:secondary_insurance_carrier_id
	    t.integer 	:primary_guarantor_contact_id
	    t.integer 	:secondary_guarantor_contact_id
	    t.string  	:primary_insurance_carrier_group_uid
	    t.string  	:secondary_insurance_carrier_group_uid
	    t.string  	:primary_insurance_carrier_policy_uid
	    t.string  	:secondary_insurance_carrier_policy_uid
	    t.string  	:hcfa_1a_primary
	    t.string  	:hcfa_1a_secondary
	    t.string  	:relationship_to_primary_guarantor
	    t.string  	:relationship_to_secondary_guarantor
	    t.boolean 	:primary_insurance_carrier_assignment, default: false
	    t.boolean 	:secondary_insurance_carrier_assignment, default: false
	    t.boolean 	:should_hold_primary_bill
	    t.boolean 	:should_hold_secondary_bill
	    t.integer 	:primary_max_pay_per_visit_cents
	    t.integer 	:secondary_max_pay_per_visit_cents
	    t.integer 	:primary_max_pay_per_year_cents
	    t.integer 	:secondary_max_pay_per_year_cents
	    t.integer 	:primary_max_visits_per_year
	    t.integer 	:secondary_max_visits_per_year
	    t.integer 	:primary_max_pay_per_life_cents
	    t.integer 	:secondary_max_pay_per_life_cents
	    t.integer 	:primary_max_visits_per_life
	    t.integer 	:secondary_max_visits_per_life
	    t.integer 	:primary_deductible_cents, default: 0
	    t.integer 	:secondary_deductible_cents, default: 0
	    t.integer 	:primary_paid_cents, default: 0
	    t.integer 	:secondary_paid_cents,  default: 0
	    t.date    	:hcfa_similar_symptoms_date
	    t.boolean 	:hcfa_had_lab_work, default: false
	    t.boolean 	:hcfa_is_employment_related, default: false
	    t.boolean 	:hcfa_is_auto_accident, default: false
	    t.boolean 	:hcfa_is_non_auto_accident, default: false
	    t.string  	:hcfa_prior_authorization
	    t.string  	:hcfa_medicaid_resubmission
	    t.string  	:hcfa_original_ref
	    t.boolean 	:is_emergency, default: false
	    t.boolean 	:nys_workmanscomp_is_initial_or_final, default: false
	    t.integer 	:disability_percentage
	    t.integer 	:disability_status_code
	    t.date    	:exacerbation_date
	    t.date    	:xray_date
	    t.date    	:workmanscomp_return_to_work_date
	    t.date    	:workmanscomp_start_disability_date
	    t.date    	:workmanscomp_end_disability_date
	    t.date    	:workmanscomp_start_partial_disability_date
	    t.date    	:workmanscomp_end_partial_disability_date
	    t.datetime	:releases_from_care_date
	    t.datetime	:accident_time
	    t.date    	:accident_date
	    t.string  	:accident_state
	    t.string  	:accident_city
	    t.string  	:workmanscomp_uid
	    t.string  	:accident_description
	    t.integer 	:diagnosis1_id
	    t.string  	:diagnosis1_description, default: ':'
	    t.integer 	:diagnosis2_id
	    t.string  	:diagnosis2_description, default: ':'
	    t.integer 	:diagnosis3_id
	    t.string  	:diagnosis3_description, default: ':'
	    t.integer 	:diagnosis4_id
	    t.string  	:diagnosis4_description, default: ':'
	    t.string  	:treatment_phase
	    t.string  	:exacerbation_or_reoccurence
	    t.string  	:subx_level
	    t.string  	:hcfa_10d
	    t.boolean 	:is_xray_available, default: false
	    t.boolean 	:medicare_abn_waiver_signed, default: false
	    t.boolean 	:is_billable, default: false
	    t.text    	:notes
	    t.boolean 	:is_active, default: false
	    t.date    	:primary_authorization_through_date
	    t.date    	:secondary_authorization_through_date
	    t.datetime	:deleted_at
	    t.string  	:hcfa_accident_state
	    t.string  	:c4_accident_city
	    t.string  	:hcfa_box19_accident_description
	    t.datetime	:released_from_care_date
	    t.string  	:referrer_type
	    t.integer 	:fee_schedule_label_id
	    t.date    	:onset_at
	    t.date    	:first_treated_at
      t.timestamps null: false
    end
    add_index :patient_cases, :patient_id
    add_index :patient_cases, :provider_id
    add_index :patient_cases, :referrer_id
    add_index :patient_cases, :attorney_id
  end
end
