FactoryBot.define do
  factory :evaluation do
    association(:product)
    score { 1 }
  end
end
