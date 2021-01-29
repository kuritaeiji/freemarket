class NoticesController < ApplicationController
  before_action(:log_in_user)

  def index
    @notices = current_user.receive_notices.preload(noticeable: { messageable: { images: { attachments: :blobs } } })
      .preload(noticeable: :user)
    @notices.where(read: false).update_all(read: true)
  end
end
