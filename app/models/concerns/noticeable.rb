module Noticeable
  extend(ActiveSupport::Concern)

  included do
    has_many(:notices, as: :noticeable, dependent: :destroy)
  end
end