class Todo < ApplicationRecord
  include(Noticeable) # 発送通知
  include(Messageable)

  belongs_to(:product)
end
