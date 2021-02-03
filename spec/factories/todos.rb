FactoryBot.define do
  factory :todo do
    association(:product)
    shipped { false }
    received { false }
  end
end
