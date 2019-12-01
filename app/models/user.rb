class User < ApplicationRecord
  JWT_DURATION = 1.year
  has_secure_password

  has_many :tasks

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
end
