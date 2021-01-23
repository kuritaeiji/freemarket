class Product < ApplicationRecord
  belongs_to(:user)
  belongs_to(:shipping_day)
  belongs_to(:status)
  belongs_to(:category)

  default_scope(-> { order(id: :asc) })
end