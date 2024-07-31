class Aircraft < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :icao_code, presence: true, uniqueness: true
end
