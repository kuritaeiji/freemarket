class Todo < ApplicationRecord
  include(Noticeable) # 発送通知
  include(Messageable)

  belongs_to(:product)

  def can_send_message?(current_user)
    flag = false
    if current_user == product.sell_user || current_user == product.purchace_user
      flag = !received?
    end
    return flag
  end
end
