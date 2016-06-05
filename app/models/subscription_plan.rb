class SubscriptionPlan < ActiveRecord::Base
	include ActionView::Helpers::NumberHelper

	## Scopes
	scope :latest, -> { order('created_at DESC')}

	## Relationship
	belongs_to :plan
	
	## validations
	validates :name, :plan_id, presence: true
	validates :renewal_period, :trial_period, numericality: {allow_blank: true, only_integer: true, greater_than: 0}

	def to_s
    "#{name} - #{number_to_currency(amount)} / month"
  end

end
