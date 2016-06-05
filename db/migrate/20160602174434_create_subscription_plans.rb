class CreateSubscriptionPlans < ActiveRecord::Migration
  def change
    create_table 	:subscription_plans do |t|
    	t.integer 	:plan_id
      t.string 		:name
	    t.decimal  	:amount, precision: 10, scale: 2
    	t.integer  	:user_limit 
	    t.integer  	:renewal_period, default: 1
	    t.decimal  	:setup_amount, precision: 10, scale: 2
	    t.integer  	:trial_period, default: 1
	    t.integer  	:patient_limit
	    t.integer  	:events_limit
	    t.integer  	:emarketing_campaigns_limit_per_month
	    t.integer  	:clinic_limit
	    t.integer  	:office_staff_limit
	    t.integer  	:provider_limit
	    t.integer  	:file_storage_limit_megabytes
	    t.boolean  	:is_import_export_limited
	    t.boolean  	:is_hcfa_printing_limited
	    t.boolean  	:is_invoicing_limited
	    t.boolean  	:time_tracking
	    t.boolean  	:is_appointment_scheduling_limited
	    t.boolean  	:online_patient_scheduling
	    t.boolean  	:website_templates
	    t.boolean  	:vendor_integration
	    t.boolean  	:inventory_tracking
	    t.boolean  	:own_domain_name
	    t.boolean  	:soap_note_report_writer
	    t.boolean  	:address_verification
	    t.boolean  	:labs_integration
	    t.boolean  	:user_tracking_and_auditing
	    t.boolean  	:daily_backups
	    t.boolean  	:bookkeeping
	    t.boolean  	:custom_transaction_gateway
	    t.decimal  	:yearly_amount, precision: 10
	    t.boolean  	:is_user_tracking_and_auditing_limited
	    t.boolean  	:is_online_patient_scheduling_limited
	    t.boolean   :is_website_templates_limited
	    t.boolean  	:is_office_staff_unlimited
      t.timestamps null: false
    end
  end
end
