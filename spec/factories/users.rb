FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@test.com" }
    password { 'Password1010' }
    password_confirmation { 'Password1010' }
    account_name { 'ニックネーム' }
    family_name { '佐藤' }
    first_name { '太郎' }
    postal_code { 1112345 }
    association(:prefecture)
    address { '杉並区' }
    activated { true }
    image { fixture_file_upload('spec/images/a.jpg', 'image/jpg') }

    trait(:valid_params) do
      prefecture_id { FactoryBot.create(:prefecture).id }
    end

    trait(:invalid_params) do
      email { nil }
    end

    trait(:with_uid) do
      uid { '12345' }
    end
  end
end
