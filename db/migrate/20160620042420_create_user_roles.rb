class CreateUserRoles < ActiveRecord::Migration
  def change
    create_table :user_roles do |t|
      t.string 		:name
	    t.string  	:appointments
	    t.string  	:attorneys
	    t.string  	:letters
	    t.string  	:paragraphs
	    t.string   	:reports
	    t.string   	:statements
	    t.string   	:narratives
	    t.boolean  	:can_see_day_stats
	    t.boolean  	:can_see_month_stats
	    t.boolean  	:can_see_year_stats
	    t.boolean  	:can_see_clinic_transactions
	    t.integer  	:clinic_id
	    t.string   	:patient_visit_details
	    t.string   	:patient_bills
	    t.string   	:clinic_preferences
	    t.string   	:clinics
	    t.string   	:account_roles
	    t.string   	:accounts
	    t.string   	:addresses
	    t.string   	:contacts
	    t.string   	:diagnosis_codes
	    t.string   	:ebill_setups
	    t.string   	:fee_schedules
	    t.string   	:insurance_carriers
	    t.string   	:legacy_ids
	    t.string   	:patient_cases
	    t.string   	:patient_visit_payments
	    t.string   	:patient_visits
	    t.string   	:patients
	    t.string   	:procedure_codes
	    t.string   	:providers
	    t.string   	:referrers
	    t.string   	:rooms
	    t.datetime 	:deleted_at
      t.timestamps null: false
    end
  end
end
