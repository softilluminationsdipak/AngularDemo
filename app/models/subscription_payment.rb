class SubscriptionPayment < ActiveRecord::Base

	## Relationship
	belongs_to :subscription
	belongs_to :account
	belongs_to :affiliate, class_name: 'SubscriptionAffiliate', foreign_key: 'subscription_affiliate_id'

end
