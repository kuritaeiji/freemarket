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

  # messgeableとしての責務
  def can_send_message?(current_user)
    if current_user == product.sell_user || current_user == product.purchace_user
      return !product.received?
    end
    return false
  end

  def create_notice(message)
    if message.user == product.purchace_user
      message.notices.create(send_user: message.user, receive_user: product.sell_user)
    elsif message.user == product.sell_user
      message.notices.create(send_user: message.user, receive_user: product.purchace_user)
    end
  end

  # messageableとしての責務
  def notice_messageable_body(message)
    "#{message.user.account_name}が#{product.name}にメッセージを送りました。"
  end

  def notice_messageable_image
    product.images[0]
  end

  def notice_messageable_path
    received? ? '#' : todo_path(self)
  end

  # noticeableとしての責務
  def notice_body
    "#{product.purchace_user.account_name}が商品#{product.name}を受けとったため取引が終了しました。"
  end

  def notice_path
    '#'
  end

  def notice_image
    product.images[0]
  end
end
