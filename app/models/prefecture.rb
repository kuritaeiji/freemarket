class Prefecture < ApplicationRecord
  has_many(:users)
  default_scope(-> { order(id: :asc) })
end
