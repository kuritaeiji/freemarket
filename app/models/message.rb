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

  private
    def create_notice
      if messageable_type == 'Product'
        ProductMessageCreateNotice.create_notice(self)
      elsif messageable_type == 'TradeProduct'
      end
    end
end
