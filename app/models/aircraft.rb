class Aircraft < ApplicationRecord
  has_many :fleets, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :icao_code, presence: true, uniqueness: true
end
