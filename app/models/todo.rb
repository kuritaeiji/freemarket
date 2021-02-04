class Todo < ApplicationRecord
  include(Noticeable) # 取引終了通知
  include(Messageable)

  belongs_to(:product)

  after_update_commit do
    messages.create(user: product.sell_user, content: '商品を発送しました。') if saved_change_to_shipped? # 発送通知
  end

  after_update_commit do
    notices.create(send_user: product.purchace_user, receive_user: product.sell_user) if saved_change_to_received?
  end

  def can_send_message?(current_user)
    if current_user == product.sell_user || current_user == product.purchace_user
      return !product.received?
    end
    return false
  end

  def create_notice(message) # messgeableとしての責務
    if message.user == product.purchace_user
      message.notices.create(send_user: message.user, receive_user: product.sell_user)
    elsif message.user == product.sell_user
      message.notices.create(send_user: message.user, receive_user: product.purchace_user)
    end
  end
end
