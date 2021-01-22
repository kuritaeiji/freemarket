require("csv")

CSV.foreach('db/prefectures.csv') do |row|
  Prefecture.create!(name: row[1])
end

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