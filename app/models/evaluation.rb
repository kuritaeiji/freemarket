class Evaluation < ApplicationRecord
  include(Noticeable)
  belongs_to(:purchaced_product)

  validates(:score, presence: true ,numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 3 })

  after_create_commit do
    notices.create(send_user: purchaced_product.purchace_user, receive_user: purchaced_product.sell_user)
  end
end