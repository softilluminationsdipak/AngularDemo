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
end