class LikesController < ApplicationController
  def index # GET /likes
    @likes = current_user.likes.preload(product: { images_attachments: :blob })
      .paginate(page: params[:page], per_page: 20)
  end
end
