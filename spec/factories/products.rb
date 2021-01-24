FactoryBot.define do
  factory :product do
    sequence(:name) { |i| "商品#{i}" }
    description { '商品内容' }
    sequence(:price) { |i| i * 1000 }
    trading { false }
    solded { false }
    association(:user)
    association(:shipping_day)
    association(:status)
    association(:category)
  end
end
