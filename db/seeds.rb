require("csv")

CSV.foreach('db/prefectures.csv') do |row|
  Prefecture.create!(name: row[1])
end

Category.create!(name: 'レディース')
Category.create!(name: 'メンズ')
Category.create!(name: 'ベビー・キッズ')
Category.create!(name: 'インテリア')
Category.create!(name: '本・音楽・ゲーム')
Category.create!(name: 'コスメ・美容')
Category.create!(name: '家電・スマホ・カメラ')
Category.create!(name: 'スポーツ・レジャー')
Category.create!(name: 'ハンドメイド')
Category.create!(name: 'チケット')
Category.create!(name: 'その他')

ShippingDay.create!(days: '1日')
ShippingDay.create!(days: '2~3日')
ShippingDay.create!(days: '4~5日')
ShippingDay.create!(days: '1週間')

Status.create!(name: '新品、未使用')
Status.create!(name: '目立った傷や汚れ無し')
Status.create!(name: '傷や汚れあり')
Status.create!(name: '状態が悪い')

include(ActionDispatch::TestProcess)

user = User.create!(
  email: 'test@test.com',
  password: 'Password1010',
  password_confirmation: 'Password1010',
  account_name: 'test_account',
  family_name: 'satou',
  first_name: 'tarou',
  postal_code: '1234567',
  prefecture_id: '13',
  address: '港区',
  image: fixture_file_upload("#{Rails.root}/spec/images/a.jpg", 'image/jpg'),
  activated: true
)

30.times do |n|
  User.create!(
      email: "test#{n}@test.com",
      password: 'Password1010',
      password_confirmation: 'Password1010',
      account_name: "test_account#{n}",
      family_name: "satou#{n}",
      first_name: "tarou#{n}",
      postal_code: '1234567',
      prefecture_id: '13',
      address: '港区',
      image: fixture_file_upload("#{Rails.root}/spec/images/a.jpg", 'image/jpg'),
      activated: true
    )
end

statuses = Status.all.take(2)
categories = Category.all.take(2)
shipping_days = ShippingDay.all.take(2)
users = User.all.take(10)

statuses.each do |status|
  categories.each do |category|
    shipping_days.each do |shipping_day|
      users.each do |user|
        product = Product.create!(
          name: Faker::Game.title,
          description: '商品内容',
          user: user,
          shipping_day: shipping_day,
          status: status,
          category: category,
          images: [fixture_file_upload("#{Rails.root}/spec/images/a.jpg", 'image/jpg')]
        )
      end
    end
  end
end

products = Product.all.take(10)
products.each do |product|
  users.each do |user|
    product.messages.create!(user: user, content: 'テストメッセージ')
    next if user == product.user
    user.likes.create!(product: product)
  end
end