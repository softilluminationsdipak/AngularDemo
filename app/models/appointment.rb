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

  ## Methods
  def to_s
    "#{starts_at.to_s} - #{provider.name} - #{contact.name}"
  end

  def set_starts_at
    self.starts_at = Time.utc(date.year, date.month, date.day, start_time.hour, start_time.min)
  end

  def set_ends_at
    self.ends_at = set_starts_at.advance(:minutes => duration_units * minute_units) unless date.blank? || start_time.blank?
  end
  
end
