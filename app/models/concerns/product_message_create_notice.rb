module ProductMessageCreateNotice
  def self.create_notice(message)
    sell_user = message.messageable.user # 商品を出品しているユーザー
    if message.user == sell_user # メッセージの送信者が商品の出品者である
      not_sell_user_messages = message.messageable.messages.not_sell_user_messages(sell_user) # 商品の出品者が送信者でないメッセージ
      if not_sell_user_messages
        receive_notice_users = not_sell_user_messages.map { |m| m.user } # 知らせを受け取るべきユーザーたち
        receive_notice_users.each do |u|
          message.notices.create(send_user: sell_user, receive_user: u)
        end
      end
    else # メッセージの送信者が商品の出品者でない時、出品者にお知らせを送る
      message.notices.create(send_user: message.user, receive_user: sell_user)
    end
  end
end