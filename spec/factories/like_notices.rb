FactoryBot.define do
  factory(:like_notice, class: 'Notice') do
    association(:noticeable, factory: :like)
    association(:send_user, factory: :user)
    association(:receive_user, factory: :user)
    read { false }
  end
end