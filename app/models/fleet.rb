class Fleet < ApplicationRecord
  belongs_to :aircraft
  has_and_belongs_to_many :routes

  validates :livery, presence: true

  scope :by_aircraft, ->(aircraft_id) { where(aircraft_id:) }

  def aircraft_name
    "#{aircraft.name} - #{livery}"
  end
end
