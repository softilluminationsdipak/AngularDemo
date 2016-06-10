class FeeScheduleLabel < ActiveRecord::Base
	## Relationships
	belongs_to :clinic
	belongs_to :account
	
	has_many :procedure_codes_fee_schedule_labels, dependent: :destroy
	## Scopes
	scope :ascend_by_label, -> {order('label ASC')}

	## Validations
	validates_uniqueness_of :label, case_sensitive: false, message: ' does not accepts duplicates', scope: :account_id


end
