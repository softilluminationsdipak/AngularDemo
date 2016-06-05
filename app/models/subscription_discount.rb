class SubscriptionDiscount < ActiveRecord::Base
	## Validations
	validates :name, :code, presence: true
	validates :amount, numericality: true, allow_nil: true

	## Scopes
	scope :latest, -> { order('created_at DESC')}

	## Callbacks
	before_save :check_percentage

	protected

	def check_percentage
		if amount > 1 && percent.present?
			self.amount = (amount / 100).to_f
		end
	end

end
