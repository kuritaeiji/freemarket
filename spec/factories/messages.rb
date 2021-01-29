FactoryBot.define do
  factory :message do
    content { 'メッセージ' }
    association(:user)
    association(:messageable, factory: :product)
  end
end
