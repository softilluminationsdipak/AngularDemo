class CreateClinicPreferences < ActiveRecord::Migration
  def change
    create_table :clinic_preferences do |t|
      t.integer 	:clinic_id
      t.string 		:internal_account_uid_scheme
	    t.string   	:additional_transaction_number
	    t.string   	:patient_number_scheme
	    t.string   	:transaction_number_scheme
	    t.integer  	:overdue_fee_percentage
	    t.string   	:should_use_clinic_name
	    t.boolean  	:should_print_diagnosis_description_on_hcfa, default: false
	    t.boolean  	:should_send_statements_when_overdue, default: false
	    t.boolean  	:should_charge_overdue_account, default: false
	    t.string   	:insurance_carrier_assignment_policy
	    t.boolean  	:should_show_clinic_on_letter, default: false
	    t.boolean  	:should_show_clinic_on_bill, default: false
	    t.string   	:workmanscomp_boilerplate
	    t.string   	:patient_current_statement_message
	    t.string   	:patient_30days_statement_message
	    t.string   	:patient_60days_statement_message
	    t.string   	:patient_90days_statement_message
	    t.string   	:patient_120days_statement_message
	    t.boolean  	:should_print_clinic_address_on_envelope, default: false
	    t.integer  	:payment_display_code
	    t.datetime 	:deleted_at
	    t.integer  	:should_split_bills_by_provider
	    t.integer  	:default_place_of_service
	    t.string   	:box_32_use
	    t.string   	:box_33_use
	    t.string   	:letter_use
	    t.string   	:statement_use
	    t.float    	:hcfa_left_margin
	    t.float    	:hcfa_top_margin
      t.timestamps null: false
    end
  end
end
