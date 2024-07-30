class Setting < ApplicationRecord
  belongs_to :airline_owner, class_name: 'User', foreign_key: 'owner_id', inverse_of: :airline
  has_one_attached :logo

  validates :airline_name, presence: true, uniqueness: true
  validates :callsign, presence: true, uniqueness: true
  validates :logo, attached: true, content_type: ['image/png', 'image/jpeg', 'image/gif'],
                   size: { less_than: 5.megabytes }

  def self.instance
    first
  end
end
