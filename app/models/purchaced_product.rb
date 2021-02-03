class PurchacedProduct < ApplicationRecord
  include(Noticeable) # 発送通知
  include(Messageable)
  belongs_to(:purchace_user, class_name: 'User')
  belongs_to(:product)
  has_one(:evaluation, dependent: :destroy)

  delegate(:user, to: :product, prefix: :sell)
  delegate(:name, :description, :category, :shipping_day, :status, :images, to: :product) # ほぼproductのwrapper

  default_scope(-> { eager_load(product: :user).preload(product: { images_attachments: :blob }) })

  after_create_commit do
    product.update(traded: true)
  end

  after_update_commit do
    if saved_change_to_shipped?
      notices.create(send_user: sell_user, receive_user: purchace_user)
      messages.create(user: sell_user, content: '荷物を発送しました。')
    end
  end

  after_update_commit do
    product.update(solded: true) if saved_change_to_received?
  end

  def notice_path
    purchaced_product_path(self)
  end

  def notice_body
    "#{sell_user}が#{name}を発送しました。"
  end

  def notice_image
    images[0]
  end

  def create_notice(message)
    if message.user == sell_user
      message.notices.create(send_user: sell_user, receive_user: purchace_user)
    else
      message.notices.create(send_user: purchace_user, receive_user: sell_user)
    end
  end
end