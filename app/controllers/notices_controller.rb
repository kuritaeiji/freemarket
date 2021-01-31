class NoticesController < ApplicationController
  before_action(:log_in_user)

  def index
    @notices = current_user.receive_notices.preload(noticeable: { messageable: { images_attachments: :blob } })
      .preload(noticeable: :user).preload(noticeable: { product: { images_attachments: :blob } }).paginate(page: params[:page], per_page: 20)
    @notices.where(read: false).update_all(read: true)
  end
end
