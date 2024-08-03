class Pirep < ApplicationRecord
  STATUSES = %w[pending approved rejected].freeze
  ICAO_CODE_FORMAT = /\A[A-Z]{3,4}\z/

  belongs_to :user
  belongs_to :fleet
  belongs_to :multiplier, optional: true

  attr_accessor :flight_hours, :flight_minutes

  validates :flight_number, :flight_date, :departure_icao, :arrival_icao, presence: true
  validates :flight_time_minutes, :fuel_used, :cargo,
            presence: true,
            numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :status, inclusion: { in: STATUSES }
  validates :departure_icao, :arrival_icao, format: { with: ICAO_CODE_FORMAT }, length: { in: 3..4 }

  validate :flight_date_not_in_future

  before_validation :prepare_pirep_data
  before_create :apply_multiplier
  before_destroy :remove_flight_time_from_user, if: :approved?

  scope :pending, -> { where(status: 'pending') }
  scope :approved, -> { where(status: 'approved') }
  scope :rejected, -> { where(status: 'rejected') }

  # Returns the flight time in HH:MM format
  def flight_time
    hours, minutes = flight_time_minutes.divmod(60)
    format('%<hours>02d:%<minutes>02d', hours:, minutes:)
  end

  def approve!
    transaction do
      was_approved = approved?
      update!(status: 'approved')
      add_flight_time_to_user unless was_approved
    end
  end

  def reject!
    transaction do
      was_approved = approved?
      update!(status: 'rejected')
      remove_flight_time_from_user if was_approved
    end
  end

  private

  # Prepares PIREP data before validation
  def prepare_pirep_data
    calculate_flight_time_minutes
    upcase_icao_codes
  end

  # Calculates total flight time in minutes from hours and minutes input
  def calculate_flight_time_minutes
    return if flight_hours.blank? || flight_minutes.blank?

    self.flight_time_minutes = (flight_hours.to_i * 60) + flight_minutes.to_i
  end

  # Converts ICAO codes to uppercase
  def upcase_icao_codes
    self.departure_icao = departure_icao&.upcase
    self.arrival_icao = arrival_icao&.upcase
  end

  # Applies the multiplier to the flight time if a multiplier is associated
  def apply_multiplier
    return unless multiplier

    self.flight_time_minutes = (flight_time_minutes * multiplier.value).round
  end

  # Validates that the flight date is not more than one day in the future
  def flight_date_not_in_future
    return if flight_date.blank?

    max_allowed_date = 1.day.from_now.end_of_day.in_time_zone('UTC')
    return unless flight_date.in_time_zone('UTC') > max_allowed_date

    errors.add(:flight_date, "can't be more than one day in the future")
  end

  # Adds the flight time to the user's total flight time
  def add_flight_time_to_user
    user.with_lock do
      user.flight_time += flight_time_minutes
      user.save!
    end
  end

  # Removes the flight time from the user's total flight time
  def remove_flight_time_from_user
    user.with_lock do
      user.flight_time = [user.flight_time - flight_time_minutes, 0].max
      user.save!
    end
  end

  def approved?
    status == 'approved'
  end
end
