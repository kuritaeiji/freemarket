class PurchacedProduct < ApplicationRecord
  include(Noticeable)
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
    notices.create(send_user: sell_user, receive_user: purchace_user) if saved_change_to_shipped?
  end

  after_update_commit do
    product.update(solded: true) if saved_change_to_received?
  end
end