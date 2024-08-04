class Route < ApplicationRecord
  has_and_belongs_to_many :fleets

  validates :flight_number, presence: true, uniqueness: true
  validates :departure_icao, presence: true
  validates :arrival_icao, presence: true
  validates :duration, presence: true, numericality: { greater_than: 0 }

  scope :by_departure, ->(icao) { where(departure_icao: icao) }
  scope :by_arrival, ->(icao) { where(arrival_icao: icao) }

  def flight_time
    hours, minutes = duration.divmod(60)
    format('%<hours>02d:%<minutes>02d', hours:, minutes:)
  end
end
