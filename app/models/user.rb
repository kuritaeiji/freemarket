class User < ApplicationRecord
  belongs_to(:prefecture)

  EMAIL_REGEXP = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  PASSWORD_REGEXP = /(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])[a-zA-Z0-9]+/
  validates(:email, presence: true, uniqueness: true,
    length: { maximum: 50 }, format: { with: EMAIL_REGEXP })
  validates(:password, presence: true, length: { minumum: 8, maximum: 20 },
    format: { with: PASSWORD_REGEXP }, unless: ->(user) { user.password.nil? })
  validates(:nickname, presence: true, length: { maximum: 20 })
  validates(:family_name, presence: true, length: { maximum: 20 })
  validates(:first_name, presence: true, length: { maximum: 20 })
  validates(:postal_code, presence: true, length: { maximum: 20 })
  validates(:address, presence: true, length: { maximum: 50 })

  has_secure_password

  default_scope(-> { order(id: :asc ) })
end
