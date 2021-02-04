FactoryBot.define do
  factory :product do
    sequence(:name) { |i| "商品#{i}" }
    description { '商品内容' }
    traded { false }
    solded { false }
    association(:user)
    association(:shipping_day)
    association(:status)
    association(:category)
    images { [fixture_file_upload('spec/images/a.jpg', 'image/jpg')] }

    trait(:valid_params) do
      image1 { fixture_file_upload('spec/images/a.jpg', 'image/jpg') }
      image2 { nil }
      image3 { nil }
      image4 { nil }
      shipping_day_id { FactoryBot.create(:shipping_day).id }
      status_id { FactoryBot.create(:status).id }
      category_id { FactoryBot.create(:category).id }
    end

    trait(:invalid_params) do
      image1 { nil }
      image2 { nil }
      image3 { nil }
      image4 { nil }
      shipping_day_id { nil }
      status_id { nil }
      category_id { nil }
    end

    trait(:with_multiple_images) do
      images { [fixture_file_upload('spec/images/a.jpg', 'image/jpg'), fixture_file_upload('spec/images/m.jpg', 'image/jpg')] }
    end

    factory(:purchace_product) do
      traded { true }
      association(:purchace_user, factory: :user)
    end
  end
end
