class Appointment < ActiveRecord::Base
  acts_as_paranoid
  
  RECURRING_TYPES = %w(one_time day_of_week day_of_month day_of_year)

  ## Relationships
	belongs_to :contact
	belongs_to :clinic
	belongs_to :provider
	belongs_to :room

	## Scopes
  scope :for_date, lambda { |date| where("(recurring_type = 'one_time' AND date = ?) OR (recurring_type = 'day_of_week' AND recurring_day = ?) OR (recurring_type = 'day_of_month' AND recurring_day = ?) OR (recurring_type = 'day_of_year' AND recurring_day = ?)", date.to_date.to_s(:db), date.to_date.wday, date.to_date.mday, date.to_date.yday).order(:start_time) }

  ## Callbacks
  after_create :appointment_reminder
  before_save :set_starts_at, :set_ends_at

  ## Validations
  validates :clinic_id, :contact_id, :date, :start_time, presence: true
  validates_inclusion_of :recurring_type, in: RECURRING_TYPES, allow_nil: true
  validate :time_occupied


  ## Methods
  # def to_s
  #   "#{starts_at.to_s} - #{provider.name} - #{contact.name}"
  # end

  def set_starts_at
    self.starts_at = Time.utc(date.year, date.month, date.day, start_time.hour, start_time.min)
  end

  def set_ends_at
    self.ends_at = set_starts_at.advance(minutes: duration_units * minute_units) unless date.blank? || start_time.blank?
  end
  
  def appointment_reminder
    return false if Date.tomorrow != date.to_date
  end

  def time_occupied
    set_starts_at
    set_ends_at

    if new_record?
      overlapping_appt = Appointment.where('provider_id = ? AND (starts_at <= ? AND ends_at >= ?)', provider_id, ends_at, starts_at).try(:last)
    else
      overlapping_appt = Appointment.where('id != ? AND provider_id = ? AND (starts_at <= ? AND ends_at > = ?)', id, provider_id, ends_at, starts_at).try(:last)
    end

    unless overlapping_appt.nil?
      errors.add(:base, "Another appointment exists at that time.")
    end
  end

  def units_15min
    duration_units = 1 if duration_units.nil?
    minute_units = 15 if minute_units.nil?
    (duration_units * minute_units) / 15
  end

  def to_s
    "#{starts_at.to_s} - #{provider.name} - #{contact.name}"
  end

  def self.for_today
    for_date Date.today
  end

  def self.for_tomorrow
    for_date Date.tomorrow
  end

  def self.report(clinic, date)
    appointments = clinic.appointments.where('(recurring_type = ? AND DATE(date) = ?) OR (recurring_type = ? AND recurring_day = ?) OR (recurring_type = ? AND recurring_day = ?) OR (recurring_type = ? AND recurring_day = ?)', 'one_time', date.to_date, 'day_of_week', date.to_date.wday, 'day_of_month', date.to_date.mday, 'day_of_year', date.to_date.yday)
    {
      appointments: appointments,
      date: date
    }
  end

end
