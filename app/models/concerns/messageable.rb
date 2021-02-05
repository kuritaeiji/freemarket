module Messageable
  extend(ActiveSupport::Concern)
  include(Rails.application.routes.url_helpers)

  included do
    has_many(:messages, as: :messageable, dependent: :destroy)
  end

  def create_notice(message)
    raise(NotImplementedError.new('abstract method called :create_notice. please implement create_notice'))
  end

  def can_send_message?(current_user)
    raise(NotImplementedError.new('abstract method called :can_send_message?. please implement can_send_message?'))
  end

  def notice_messageable_body(message)
    raise(NotImplementedError.new('abstract method called :notice_body. please implement notice_body'))
  end

  def notice_messageable_image
    raise(NotImplementedError.new('abstract method called :notice_product_image. please implement notice_product_image'))
  end

  def notice_messageable_path
    raise(NotImplementedError.new('abstract method called :notice_path. please implement notice_path'))
  end
end