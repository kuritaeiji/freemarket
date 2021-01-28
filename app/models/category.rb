class Category < ApplicationRecord
  has_many(:products)
  default_scope(-> { order(id: :asc) })
end
