class Pirep < ApplicationRecord
  belongs_to :user
  belongs_to :fleet
  belongs_to :multiplier, optional: true

  validates :flight_number, :flight_date, presence: true
  validates :departure_icao, :arrival_icao, presence: true,
                                            length: { in: 3..4 },
                                            format: { with: /\A[A-Z]{3,4}\z/ }
  validates :flight_time_minutes, :fuel_used, :cargo, presence: true,
                                                      numericality: { greater_than_or_equal_to: 0, only_integer: true }

  before_validation :upcase_icao_codes

  def flight_time
    hours, minutes = flight_time_minutes.divmod(60)
    format('%<hours>02d:%<minutes>02d', hours:, minutes:)
  end

  def flight_time=(time_str)
    hours, minutes = time_str.split(':').map(&:to_i)
    self.flight_time_minutes = (hours * 60) + minutes
  end

  private

  def upcase_icao_codes
    self.departure_icao = departure_icao.upcase if departure_icao.present?
    self.arrival_icao = arrival_icao.upcase if arrival_icao.present?
  end
end
