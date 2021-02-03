FactoryBot.define do
  factory :evaluation do
    association(:purchaced_product)
    score { 1 }
  end
end
