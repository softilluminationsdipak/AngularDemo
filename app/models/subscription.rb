class Subscription < ActiveRecord::Base
	## Relationships
	belongs_to :account
	belongs_to :subscription_plan
	belongs_to :discount, class_name: 'SubscriptionDiscount', foreign_key: 'subscription_discount_id'
	belongs_to :affiliate, class_name: 'SubscriptionAffiliate', foreign_key: 'subscription_affiliate_id'

	has_many :subscription_payments, dependent: :destroy

	## callbacks
	before_create :set_renewal_at

	## sCOPES
	scope :latest, -> { order('created_at DESC')}

	## Validations	
  validates :amount, numericality: { greater_than_or_equal_to: 0 }	

	## Methods
	def set_renewal_at
    return if subscription_plan.nil? || next_renewal_at.present?
    self.next_renewal_at = Time.now.advance(months: subscription_plan.renewal_period)		
	end

	def needs_payment_info?
    subscription_plan.amount > 0
  end	

  def trial_days
    (next_renewal_at.to_i - Time.now.to_i) / 86400
  end

end
