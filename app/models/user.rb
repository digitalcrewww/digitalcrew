class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_one :airline, class_name: 'Setting', foreign_key: 'owner_id', dependent: :destroy, inverse_of: :airline_owner

  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 30 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

  def active_sessions
    sessions.active
  end
end
