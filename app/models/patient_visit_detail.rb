class PatientVisitDetail < ActiveRecord::Base
  acts_as_paranoid

	## Relationship
	belongs_to :patient_visit
	belongs_to :provider
	belongs_to :procedure_code

	has_one :patient_case, through: :patient_visit

  has_many :incoming_payments, foreign_key: :destination_patient_visit_detail_id, class_name: 'PatientVisitPayment', dependent: :destroy
  has_many :outcoming_payments, foreign_key: :source_patient_visit_detail_id, class_name: 'PatientVisitPayment', dependent: :destroy

  ## Validations
  validates :amount_cents, :units_sold, :patient_visit_id, :procedure_code_id, :provider, presence: true
  validates :amount_cents, :units_sold, numericality: { only_integer: true }

  ## Custom Validation
  # validate :validate_amount_is_balanced_with_owes, :validate_if_patient_owes_all
  # validate :validate_sum_of_owes_should_not_change, on: :update

  ## Delegates
  delegate :is_payment?, to: :procedure_code
  delegate :is_service?, to: :procedure_code
  delegate :is_adjustment?, to: :procedure_code
  delegate :is_patient_adjustment?, to: :procedure_code
  delegate :is_insurance_adjustment?, to: :procedure_code
  delegate :is_patient_payment?, to: :procedure_code
  delegate :is_insurance_payment?, to: :procedure_code

  ## Attr Accessor
  attr_accessor :patient_case_id, :validate_presence_of_provider, :dont_use_payment_helper, :should_use_reducement_helper, :reduced_in_cents, :dont_distribute_payments, :original_amount

  ## Callbacks
  before_create :calculate_patient_owes, :calculate_insurance_owes
  before_save :zero_amount_if_helper_should_be_used, :use_reducement_helper_if_payment_amount_is_reduced

	def service
    if procedure_code.present? && procedure_code.is_service?
      amount_cents = self.amount_cents
      amount_cents = 0 unless amount_cents.present?
      amount_cents * units_sold
    else
      0
    end		
	end

  def is_payment?
    procedure_code.present? ? procedure_code.is_payment? : false
  end

  def paid
    (procedure_code.present? && procedure_code.is_payment?) ? amount_cents : 0
  end

  def adjust
    (procedure_code.present? && procedure_code.is_adjustment?) ? amount_cents : 0
  end

  def patient_owes_reduced
    previously_payed = incoming_payments.collect{ |payment|
      payment.amount_cents if payment.source_patient_visit_detail and (payment.source_patient_visit_detail.is_patient_payment? or payment.source_patient_visit_detail.is_patient_adjustment?)
    }.compact.sum
    patient_owes_cent.to_i - previously_payed
  end

  def insurance_owes_reduced
    previously_payed = incoming_payments.collect{ |payment|
      payment.amount_cents if payment.source_patient_visit_detail and (payment.source_patient_visit_detail.is_insurance_payment? or payment.source_patient_visit_detail.is_insurance_adjustment?)
    }.compact.sum
    insurance_owes_cents.to_i - previously_payed
  end

  def service_in_dollars
    "#{service.to_f}"
  end

  def can_delete?
    incoming_payments.each do |v|
      # Visit detail has payments applied to it from another visit
      if v.source_patient_visit_detail.patient_visit_id != self.patient_visit_id
        return false
      end
    end
    true
  end

  def applied_in_cents
    return 0 if incoming_payments.blank?
    incoming_payments.all.sum{|a| a.amount_cents}
  end

  def adjusted_on_detail_in_cents
    0
  end

  def extended
    (amount_cents || 0.0) * (units_sold || 0.0)
  end

  ## Callbacks
  def calculate_patient_owes    
    return patient_owes_cent if patient_owes_cent != 0 || !procedure_code.is_service?
    (self.patient_owes_cent = extended and return) if procedure_code.non_insurance_billable?
    
    unless patient_visit && patient_visit.patient_case.assigned?
      self.patient_owes_cent = extended
    else
      if defaultfee = procedure_code.default_fee(patient_visit.patient_case)
        if patient_visit.patient_case.unpaid_deductible == 0
          if defaultfee.is_percentage
            self.patient_owes_cent = extended * ((defaultfee.copay || 0).to_f / 100)
          else
            self.patient_owes_cent = (defaultfee.copay * 100 || 0)
          end
        else
          if extended > patient_visit.patient_case.unpaid_deductible
            if defaultfee.is_percentage
              self.patient_owes_cent = patient_visit.patient_case.unpaid_deductible +
                ((extended - patient_visit.patient_case.unpaid_deductible) * ((defaultfee.copay || 0).to_f / 100))
            else
              self.patient_owes_cent = patient_visit.patient_case.unpaid_deductible + (defaultfee.copay * 100 || 0)
            end
          else
            self.patient_owes_cent = extended
          end
        end
      end
    end          
  end

  # Calculate insurance_owes_cents
  def calculate_insurance_owes
    return insurance_owes_cents if insurance_owes_cents != 0 || !procedure_code.is_service?
    (self.insurance_owes_cents = 0 and return) if procedure_code.non_insurance_billable?

    self.insurance_owes_cents = extended - self.patient_owes_cents
  end

  # Should be called before save because otherwise the callback set amount_cents to 0 and
  # return value always be false
  def payment_helper_should_be_used?
    return false if self.dont_use_payment_helper
    return (
      (self.is_insurance_payment? && self.amount_cents >= 0) ||
      ((self.is_patient_payment? || self.is_patient_adjustment?) && self.amount_reduced_cents > patient_visit.patient_owes_reduced) ||
      (self.is_patient_adjustment? && self.amount_reduced_cents > patient_visit.patient_owes_reduced) ||
      (self.is_insurance_adjustment?)
    )
  end

  def zero_amount_if_helper_should_be_used
    return unless payment_helper_should_be_used?
    self.original_amount = self.amount_cents
    self.amount_cents = 0 if new_record?
    self.amount_cents = self.amount_cents_was unless new_record?
  end

  # Here we are setting the attribute of the current object that will further be checked in controller
  def use_reducement_helper_if_payment_amount_is_reduced
    cents_was = self.amount_cents_was || 0
    if self.is_payment? and self.amount_cents_changed? and self.amount_cents < cents_was
      self.should_use_reducement_helper = true
      self.reduced_in_cents = cents_was - self.amount_cents
    end
  end

  def balance_cents
    b = 0
    patient_case.patient_visits.where('DATE(visited_at) <= ?', patient_visit.visited_at) do |previous_visit|
      b += previous_visit.patient_owes_reduced
    end
    b
  end

  protected

  def validate_amount_is_balanced_with_owes
    return if procedure_code.nil? || !is_service?
    if (insurance_owes_reduced + patient_owes_reduced + applied_in_cents + adjusted_on_detail_in_cents) != extended
      errors.add(:base, "Total amount should equal the owes, payments and adjustments sum")
    end
  end

  def validate_if_patient_owes_all    
    if !procedure_code.nil? && patient_owes_cent != amount_cents && procedure_code.non_insurance_billable?
      errors.add(:base, "Patient should owe all the amount for non insurance billable procedure code.") 
    end
  end

  def validate_sum_of_owes_should_not_change
    return if amount_cents_changed?
    return if procedure_code.nil? || !is_service?
    return if !patient_owes_cent_changed? and !insurance_owes_cents_changed?
    old_sum = patient_owes_cent_was + insurance_owes_cents_was
    new_sum = patient_owes_cent + insurance_owes_cents
    errors.add(:base, "The sum of owes values should equal to the sum of old ones.") if old_sum != new_sum    
  end

end
