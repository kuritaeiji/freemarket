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
    send(url_method_name, messageable)
  end

  def notice_body
    "#{user.account_name}が#{messageable.name}にメッセージを送りました。"
  end

  def notice_image
    messageable.images[0]
  end

  private
    def url_method_name
      new_type = ''
      messageable_type.each_char do |c|
        if c.match?(/[A-Z]/)
          new_type = "#{new_type}_#{c}"
        else
          new_type = "#{new_type}#{c}"
        end
      end
      (new_type[1..-1].downcase + "_path").to_sym
    end
    
    def create_notice
      messageable.create_notice(self)
    end
end
