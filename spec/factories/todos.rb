FactoryBot.define do
  factory :todo do
    shipped { false }
    received { false }
    association(:product, factory: :purchace_product)
  end
end
