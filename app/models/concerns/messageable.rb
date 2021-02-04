module Messageable
  extend(ActiveSupport::Concern)

  included do
    has_many(:messages, as: :messageable, dependent: :destroy)
  end

  def create_notice(message)
    raise(NotImplementedError.new('abstract method called :create_notice. please implement create_notice'))
  end
end