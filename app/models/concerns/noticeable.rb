module Noticeable
  # type 'Message', 'Like', 'Evaluation', 'Todo'(取引終了通知)
  extend(ActiveSupport::Concern)
  include(Rails.application.routes.url_helpers)

  included do
    has_many(:notices, as: :noticeable, dependent: :destroy)
  end

  def notice_path
    raise(NotImplementedError.new('abstract method called :notice_path. please implement :notice_path'))
  end

  def notice_body
    raise(NotImplementedError.new('abstract method called :notice_body. please implement :notice_body'))
  end

  def notice_image
    raise(NotImplementedError.new('abstract method called :notice_image. please implement :notice_image'))
  end
end