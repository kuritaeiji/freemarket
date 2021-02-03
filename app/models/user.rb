class User < ApplicationRecord
  include(SessionsHelper)
  attr_accessor(:activation_token, :reset_token)

  belongs_to(:prefecture)
  has_many(:products, dependent: :destroy)
  has_many(:purchace_products, class_name: 'Product', foreign_key: :purchace_user_id, dependent: :destroy)
  has_many(:messages, dependent: :destroy)
  has_many(:receive_notices, class_name: 'Notice', foreign_key: 'receive_user_id', dependent: :destroy)
  has_many(:send_notices, class_name: 'Notice', foreign_key: 'send_user_id', dependent: :destroy)
  has_many(:likes, dependent: :destroy)
  has_many(:like_products, through: :likes, source: :product)

  has_one_attached(:image, dependent: :destroy)

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
    numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 47, only_interger: true })
  validates(:image, file_present: true, content_type: true, file_size: true)

  has_secure_password

  default_scope(-> { with_attached_image.order(id: :asc ) })

  after_create_commit(:prepare_account_activation, if: ->(user) { user.uid.nil? })

  def authenticate?(token, digest_symbol)
    digest = send(digest_symbol)
    return false if digest.nil?
    BCrypt::Password.new(digest) == token
  end

  def create_reset_token_and_digest
    self.reset_token = new_token
    self.reset_digest = to_digest(reset_token)
    save
  end

  def like?(product)
    like_products.include?(product)
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
