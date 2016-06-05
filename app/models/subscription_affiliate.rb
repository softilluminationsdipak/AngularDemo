class SubscriptionAffiliate < ActiveRecord::Base
	## Relationships
	has_many :subscription_payments
	has_many :subscriptions

  ## Validations
  validates :token, presence: true, uniqueness: true
  validates :rate, numericality: {allow_blank: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 1}

  ## Scopes
  scope :latest, -> { order('created_at DESC')}

  def fees
  	start_date 	= (Time.now.beginning_of_month - 1).beginning_of_month.to_date.strftime('%d/%m/%Y').to_date
  	end_date 		= (Time.now.beginning_of_month - 1).end_of_month.to_date.strftime('%d/%m/%Y').to_date
  	period = (start_date..end_date).to_a
    subscription_payments.where('DATE(created_at) IN (?)', period).collect(&:affiliate_amount).sum
  end
		
end
