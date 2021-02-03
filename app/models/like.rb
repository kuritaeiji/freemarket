class Like < ApplicationRecord
  include(Noticeable)
  belongs_to(:user)
  belongs_to(:product)

  validates(:user_id, uniqueness: { scope: :product_id })

  after_create_commit(-> { notices.create(receive_user: product.user, send_user: user) })
  before_destroy(-> { notices.destroy_all })

  def notice_path
    product_path(product)
  end

  def notice_body
    "#{user.account_name}が#{product.name}にいいね！しました。"
  end

  def notice_image
    product.images[0]
  end
end
