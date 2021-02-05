class Message < ApplicationRecord
  include(Noticeable)
  belongs_to(:messageable, polymorphic: true)
  belongs_to(:user)

  validates(:content, presence: true, length: { maximum: 200 })
  default_scope { order(created_at: :asc) }

  after_create_commit(:create_notice)

  scope('not_sell_user_messages', -> (sell_user) {
    where.not(user: sell_user)
  })

  def notice_path
    messageable.notice_messageable_path
  end

  def notice_body
    messageable.notice_messageable_body(self)
  end

  def notice_image
    messageable.notice_messageable_image
  end

  private
    def create_notice
      messageable.create_notice(self)
    end
end
