class Message < ApplicationRecord
  belongs_to(:messageable, polymorphic: true)
  belongs_to(:user)

  validates(:content, presence: true, length: { maximum: 200 })
  default_scope { order(created_at: :asc) }
end
