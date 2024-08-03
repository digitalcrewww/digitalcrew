class Fleet < ApplicationRecord
  belongs_to :aircraft

  validates :livery, presence: true

  def aircraft_name
    "#{aircraft.name} - #{livery}"
  end
end
