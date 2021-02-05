FactoryBot.define do
  factory :purchaced_product do
    association(:product)
    association(:purchace_user, factory: :user)
    shipped { false }
    received { false }
  end
end
