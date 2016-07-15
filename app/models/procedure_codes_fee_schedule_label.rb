require 'csv'
class ProcedureCodesFeeScheduleLabel < ActiveRecord::Base
	
	## Relationships
	belongs_to :procedure_code
	belongs_to :fee_schedule_label, autosave: true, validate: true
	accepts_nested_attributes_for :fee_schedule_label

	## Validations
	validates :fee_cents, :copay, numericality: { greater_than: 0}, allow_blank: true

	## Scopes
	scope :active, -> {where("fee_cents IS NOT NULL AND fee_cents != 0")}
  scope :fee_cents_gt, -> (number) { where("fee_cents >= ?", number) }

	def fee_in_dollars
		fee_cents
	end

	def expected_insurance_payment_in_dollars
		expected_insurance_payment_cents
	end

end
