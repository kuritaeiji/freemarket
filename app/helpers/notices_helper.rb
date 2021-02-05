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
end
