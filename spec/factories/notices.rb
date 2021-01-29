FactoryBot.define do
  factory :notice do
    association(:noticeable, factory: :message)
    association(:send_user, factory: :user)
    association(:receive_user, factory: :user)
    read { false }
  end
end
