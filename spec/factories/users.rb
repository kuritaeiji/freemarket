FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@test.com" }
    password { 'Password1010' }
    password_confirmation { 'Password1010' }
    nickname { 'ニックネーム' }
    family_name { '佐藤' }
    first_name { '太郎' }
    postal_code { 1112345 }
    association(:prefecture)
    address { '杉並区' }
    activated { true }
  end
end
