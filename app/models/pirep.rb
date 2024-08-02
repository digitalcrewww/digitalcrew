class Pirep < ApplicationRecord
  belongs_to :user
  belongs_to :fleet
  belongs_to :multiplier, optional: true

  attr_accessor :flight_hours, :flight_minutes

  validates :flight_number, :flight_date, presence: true
  validates :departure_icao, :arrival_icao, presence: true,
                                            length: { in: 3..4 },
                                            format: { with: /\A[A-Z]{3,4}\z/ }
  validates :flight_time_minutes, :fuel_used, :cargo, presence: true,
                                                      numericality: { greater_than_or_equal_to: 0, only_integer: true }

  before_validation :calculate_flight_time_minutes, :upcase_icao_codes
  after_save :update_user_flight_time
  after_destroy :decrease_user_flight_time

  def flight_time
    hours, minutes = flight_time_minutes.divmod(60)
    format('%<hours>02d:%<minutes>02d', hours:, minutes:)
  end

  private

  def calculate_flight_time_minutes
    return if flight_hours.nil? || flight_minutes.nil?
    self.flight_time_minutes = (flight_hours.to_i * 60) + flight_minutes.to_i
  end

  def upcase_icao_codes
    self.departure_icao = departure_icao.upcase if departure_icao.present?
    self.arrival_icao = arrival_icao.upcase if arrival_icao.present?
  end

  def update_user_flight_time
    user.increment!(:flight_time, flight_time_minutes)
  end

  def decrease_user_flight_time
    user.decrement!(:flight_time, flight_time_minutes)
  end
end
