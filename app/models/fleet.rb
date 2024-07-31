class Fleet < ApplicationRecord
  belongs_to :aircraft

  validates :livery, presence: true
end
