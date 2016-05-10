namespace :db do
  desc "----  1. Add Plans --------------"
  task add_plans: :environment do  ## rake db:add_plans
  	Plan.create(name: 'Max', 			price: 129, title: 'Corporate level', 	clinic: nil, 	doctor: nil, 	primary: false)
  	Plan.create(name: 'Plus', 		price: 49,  title: 'Most popular plan', clinic: 5, 		doctor: 5, 		primary: true)
  	Plan.create(name: 'Basic', 		price: 19,  title: 'For individuals', 	clinic: 2, 		doctor: 2, 		primary: false)
  	Plan.create(name: 'Free', 		price: 0,   title: 'For everyone', 			clinic: 1, 		doctor: 1, 		primary: false)
  end
end