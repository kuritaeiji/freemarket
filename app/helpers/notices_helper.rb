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
    product = return_product(notice)
    image_tag(product.images[0].variant(gravity: :center, resize:"50x50^", crop:"50x50+0+0").processed,
    alt: "#{product.name}の画像")
  end

  def notice_body(notice)
    send_message_user = notice.noticeable.user
    product = return_product(notice)
    if notice.noticeable_type == 'Message'
      "#{send_message_user.account_name}が#{product.name}にメッセージを送りました。"
    else
      "#{send_message_user.account_name}が#{product.name}にいいね！しました。"
    end
  end

  def notice_path(notice)
    product = return_product(notice)
    product_path(product.id)
  end

  private
    def return_product(notice)
      notice.noticeable_type == 'Message' ? notice.noticeable.messageable : notice.noticeable.product
    end
end
