class Plan < ActiveRecord::Base
	
	def price_with_month
		"#{price}/month"
	end

	def total_clinic
		clinic.present? ? clinic : 'Unlimited'
	end

	def total_doctors
		doctor.present? ? doctor : 'Unlimited'
	end

	def price_with_dollar
		"$#{price}"
	end
	
end
