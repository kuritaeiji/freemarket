class User < ApplicationRecord
  include(SessionsHelper)
  attr_accessor(:activation_token, :reset_token)

  belongs_to(:prefecture)
  has_many(:products)

  has_one_attached(:image)

  EMAIL_REGEXP = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  PASSWORD_REGEXP = /(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])[a-zA-Z0-9]+/
  POSTAL_CODE_REGEXP = /\A[0-9]{7}\z/
  validates(:email, presence: true, uniqueness: { case_sensitive: false },
    length: { maximum: 50 }, format: { with: EMAIL_REGEXP })
  validates(:password, presence: true, length: { in: 8..20 },
    format: { with: PASSWORD_REGEXP }, allow_nil: true)
  validates(:account_name, presence: true, length: { maximum: 20 })
  validates(:family_name, presence: true, length: { maximum: 20 })
  validates(:first_name, presence: true, length: { maximum: 20 })
  validates(:postal_code, presence: true, format: { with: POSTAL_CODE_REGEXP })
  validates(:address, presence: true, length: { maximum: 50 })
  validates(:prefecture_id, presence: true,
    numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 47, only_interger: true }, unless: -> { Rails.env.test? })
  validates(:image, file_present: true, content_type: true, file_size: true)

  has_secure_password

  default_scope(-> { order(id: :asc ) })

  after_create_commit(:prepare_account_activation, if: ->(user) { user.uid.nil? })

  def authenticate?(token, digest_symbol)
    BCrypt::Password.new(send(digest_symbol)) == token
  end

  def create_reset_token_and_digest
    self.reset_token = new_token
    self.reset_digest = to_digest(reset_token)
    save
  end

  private
    def prepare_account_activation
      create_account_activation_token_and_digest
      UserMailer.send_account_activation_mail(self).deliver_now
    end

    def create_account_activation_token_and_digest
      self.activation_token = new_token
      self.activation_digest = to_digest(activation_token)
      save
    end
end
