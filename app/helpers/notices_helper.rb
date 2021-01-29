module NoticesHelper
  def notice_class
    if current_user.receive_notices.where(read: false).count > 0
      'present-notice'
    end
  end

  def notice_count
    count = current_user.receive_notices.where(read: false).count
    count.to_s + '件' if count > 0
  end

  def notice_image(notice)
    if notice.noticeable_type == 'Message'
      product = notice.noticeable.messageable
      image_tag(product.images[0].variant(gravity: :center, resize:"50x50^", crop:"50x50+0+0").processed,
        alt: "#{product.name}の画像")
    end
  end

  def notice_body(notice)
    if notice.noticeable_type == 'Message'
      send_message_user = notice.noticeable.user
      product = notice.noticeable.messageable
      "#{send_message_user.account_name}が#{product.name}にメッセージを送りました。"
    end
  end

  def notice_path(notice)
    if notice.noticeable_type == 'Message'
      product = notice.noticeable.messageable
      product_path(product.id)
    end
  end
end
