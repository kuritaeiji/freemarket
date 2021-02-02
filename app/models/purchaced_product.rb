class PurchacedProduct < ApplicationRecord
  belongs_to(:purchace_user, class_name: 'User')
  belongs_to(:product)
  has_one(:todo)

  delegate(:user, to: :product, prefix: :sell)
  delegate(:name, :description, :category, :shipping_day, :status, :images, to: :product) # ほぼproductのwrapper

  # shipped: false 発送通知ボタン
  # shipped: true, received: false 評価ボタン product_solded: true
  # received: true todoを閉じる
end