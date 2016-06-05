namespace :db do
  desc "----  1. Add Plans --------------"
  task add_plans: :environment do  ## rake db:add_plans
  	Plan.create(name: 'Max', 			price: 129, title: 'Corporate level', 	clinic: nil, 	doctor: nil, 	primary: false)
  	Plan.create(name: 'Plus', 		price: 49,  title: 'Most popular plan', clinic: 5, 		doctor: 5, 		primary: true)
  	Plan.create(name: 'Basic', 		price: 19,  title: 'For individuals', 	clinic: 2, 		doctor: 2, 		primary: false)
  	Plan.create(name: 'Free', 		price: 0,   title: 'For everyone', 			clinic: 1, 		doctor: 1, 		primary: false)
  end

  desc "------2. Add Plan Facilities ------------------"
  task add_plan_facility: :environment do ## rake db:add_plan_facility
  	max_plan = Plan.find_by(name: 'Max')
  	['Patient Record Management', 'Unlimited E-marketing', 'Unlimited Office Staff', 'Custom Transaction Gateway', 'Full Security (SSL/HIPPA Compliant)', 'Unlimited Import/Export Records', 'Unlimited Electronic Insurance', 'Billing/HCFA Printing', 'Unlimited Patient Invoicing / Statements', 'Unlimited Appointment Scheduling', 'Unlimited User Tracking and Auditing', 'Unlimited Online Patient Scheduling', 'Unlimited Website Templates (CSS/SEO Tools)', 'Use Your Own Domain Name', 'Time tracking', 'Vendor Integration', 'Inventory Tracking', 'SOAP Note Report Writer', 'Address Verification', 'Labs Integration', 'Daily Backups', 'Bookkeeping (w/Less Accounting?)'].each do |item|
  		max_plan.plan_facilities.find_or_create_by(name: item)
  	end

  	# premium_plan = Plan.find_by(name: 'Premium')
  	# ['Patient Record Management', '20/month E-marketing', '5 Users Office Staff', 'Custom Transaction Gateway', 'Full Security (SSL/HIPPA Compliant)', 'Unlimited Import/Export Records', 'Unlimited Electronic Insurance', 'Billing/HCFA Printing', 'Unlimited Patient Invoicing / Statements', 'Unlimited Appointment Scheduling', 'Unlimited User Tracking and Auditing', 'Unlimited Online Patient Scheduling', 'Unlimited Website Templates (CSS/SEO Tools)', 'Use Your Own Domain Name', 'Time tracking', 'Vendor Integration', 'Inventory Tracking', 'SOAP Note Report Writer', 'Address Verification', 'Labs Integration'].each do |item|
  	# 	premium_plan.plan_facilities.find_or_create_by(name: item)
  	# end

  	plus_plan = Plan.find_by(name: 'Plus')
  	['Patient Record Management', '15/month E-marketing', '2 Users Office Staff', 'Custom Transaction Gateway', 'Full Security (SSL/HIPPA Compliant)', 'Unlimited Import/Export Records', 'Unlimited Electronic Insurance', 'Billing/HCFA Printing', 'Unlimited Patient Invoicing / Statements', 'Unlimited Appointment Scheduling', 'Unlimited User Tracking and Auditing', 'Unlimited Online Patient Scheduling', 'Unlimited Website Templates (CSS/SEO Tools)', 'Use Your Own Domain Name', 'Time tracking', 'Vendor Integration', 'Inventory Tracking', 'SOAP Note Report Writer'].each do |item|
  		plus_plan.plan_facilities.find_or_create_by(name: item)
  	end

  	basic_plan = Plan.find_by(name: 'Basic')
  	['Patient Record Management', '5/month E-marketing', 'Full Security (SSL/HIPPA Compliant)', 'Unlimited Import/Export Records', 'Unlimited Electronic Insurance', 'Billing/HCFA Printing', 'Unlimited Patient Invoicing / Statements', 'Unlimited Appointment Scheduling', 'Limited User Tracking and Auditing', 'Limited Online Patient Scheduling', 'Limited Website Templates (CSS/SEO Tools)', 'Time tracking'].each do |item|
  		basic_plan.plan_facilities.find_or_create_by(name: item)
  	end

  	free_plan = Plan.find_by(name: 'Free')
  	['Patient Record Management', '1/month E-marketing', 'Full Security (SSL/HIPPA Compliant)', 'Limited Import/Export Records', 'Limited Electronic Insurance', 'Billing/HCFA Printing', 'Limited Patient Invoicing / Statements', 'Limited Appointment Scheduling'].each do |item|
  		free_plan.plan_facilities.find_or_create_by(name: item)
  	end
  end
  
  desc "--------3. Create Admin------------------------"
  task add_admin_for_system: :environment do ## rake db:add_admin_for_system
    account = Account.find_or_create_by(name: 'admin', domain: 'admin')
    user    = account.users.build(firstname: 'Admin', lastname: 'Admin', username: 'admin', email: '11dipak.contact@gmail.com', password: 'password', password_confirmation: 'password', system_admin: true)
    user.skip_confirmation!
    user.save!
  end

  desc '------------4---Subscription Plans----------------------'
  task add_subscription_plan: :environment do ## rake db:add_subscription_plan

    max_plan = Plan.find_by(name: 'Max')
    plus_plan = Plan.find_by(name: 'Plus')
    basic_plan = Plan.find_by(name: 'Basic')
    free_plan = Plan.find_by(name: 'Free')

    SubscriptionPlan.create(name: '$0',  plan_id: free_plan.id, amount: 0.0,    user_limit: nil, renewal_period: 1, trial_period: 1, patient_limit: 0, emarketing_campaigns_limit_per_month: 1,   clinic_limit: 1,  office_staff_limit: 0, provider_limit: 1,   is_import_export_limited: true,  is_hcfa_printing_limited: true,  is_invoicing_limited: true,  time_tracking: false, is_appointment_scheduling_limited: true,  online_patient_scheduling: false, website_templates: false, vendor_integration: false, inventory_tracking: false, own_domain_name: false, soap_note_report_writer: false, address_verification: false, labs_integration: false, user_tracking_and_auditing: false, daily_backups: false, bookkeeping: false, custom_transaction_gateway: false, yearly_amount: 0,    is_user_tracking_and_auditing_limited: false, is_online_patient_scheduling_limited: false, is_website_templates_limited: false, is_office_staff_unlimited: false)
    SubscriptionPlan.create(name: '$129', plan_id: max_plan.id, amount: 129.0,  user_limit: nil, renewal_period: 1, trial_period: 1, patient_limit: 0, emarketing_campaigns_limit_per_month: 0,   clinic_limit: 0,  office_staff_limit: 0, provider_limit: 0,   is_import_export_limited: false, is_hcfa_printing_limited: false, is_invoicing_limited: false, time_tracking: true,  is_appointment_scheduling_limited: false, online_patient_scheduling: true,  website_templates: true,  vendor_integration: true,  inventory_tracking: true,  own_domain_name: true,  soap_note_report_writer: true,  address_verification: true,  labs_integration: true,  user_tracking_and_auditing: true,  daily_backups: true,  bookkeeping: true,  custom_transaction_gateway: true,  yearly_amount: 1999, is_user_tracking_and_auditing_limited: false, is_online_patient_scheduling_limited: false, is_website_templates_limited: false, is_office_staff_unlimited: true)
    SubscriptionPlan.create(name: '$19',  plan_id: basic_plan.id, amount: 19.0,   user_limit: nil, renewal_period: 1, trial_period: 1, patient_limit: 0, emarketing_campaigns_limit_per_month: 5,   clinic_limit: 2,  office_staff_limit: 0, provider_limit: 2,   is_import_export_limited: false, is_hcfa_printing_limited: false, is_invoicing_limited: false, time_tracking: true,  is_appointment_scheduling_limited: false, online_patient_scheduling: true,  website_templates: true,  vendor_integration: false, inventory_tracking: false, own_domain_name: false, soap_note_report_writer: false, address_verification: false, labs_integration: false, user_tracking_and_auditing: true,  daily_backups: false, bookkeeping: false, custom_transaction_gateway: false, yearly_amount: 499,  is_user_tracking_and_auditing_limited: true,  is_online_patient_scheduling_limited: true,  is_website_templates_limited: true,  is_office_staff_unlimited: false)
    SubscriptionPlan.create(name: '$49',  plan_id: plus_plan.id, amount: 49.0,   user_limit: nil, renewal_period: 1, trial_period: 1, patient_limit: 0, emarketing_campaigns_limit_per_month: 15,  clinic_limit: 5,  office_staff_limit: 2, provider_limit: 5,   is_import_export_limited: false, is_hcfa_printing_limited: false, is_invoicing_limited: false, time_tracking: true,  is_appointment_scheduling_limited: false, online_patient_scheduling: true,  website_templates: true,  vendor_integration: true,  inventory_tracking: true,  own_domain_name: true,  soap_note_report_writer: true,  address_verification: false, labs_integration: false, user_tracking_and_auditing: true,  daily_backups: false, bookkeeping: false, custom_transaction_gateway: true,  yearly_amount: 999,  is_user_tracking_and_auditing_limited: false, is_online_patient_scheduling_limited: false, is_website_templates_limited: false, is_office_staff_unlimited: false)
    #SubscriptionPlan.create(name: '$99',  amount: 99.0,   user_limit: nil, renewal_period: 1, trial_period: 1, patient_limit: 0, emarketing_campaigns_limit_per_month: 20,  clinic_limit: 10, office_staff_limit: 5, provider_limit: 10,  is_import_export_limited: false, is_hcfa_printing_limited: false, is_invoicing_limited: false, time_tracking: true,  is_appointment_scheduling_limited: false, online_patient_scheduling: true,  website_templates: true,  vendor_integration: true,  inventory_tracking: true,  own_domain_name: true,  soap_note_report_writer: true,  address_verification: true,  labs_integration: true,  user_tracking_and_auditing: true,  daily_backups: false, bookkeeping: false, custom_transaction_gateway: true,  yearly_amount: 1499, is_user_tracking_and_auditing_limited: false, is_online_patient_scheduling_limited: false, is_website_templates_limited: false, is_office_staff_unlimited: false)
  end

end