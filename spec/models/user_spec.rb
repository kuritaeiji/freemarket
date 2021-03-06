require 'rails_helper'
include(SessionsHelper)

RSpec.describe User, type: :model do
  # it { is_expected.to belong_to(:prefecture) }
  # it { is_expected.to have_many(:products).dependent(:destroy) }
  # it { is_expected.to have_many(:purchace_products).class_name('Product').with_foreign_key(:purchace_user_id).dependent(:destroy) }
  # it { is_expected.to have_many(:messages).dependent(:destroy) }
  # it { is_expected.to have_many(:send_notices).class_name('Notice').with_foreign_key(:send_user_id).dependent(:destroy) }
  # it { is_expected.to have_many(:receive_notices).class_name('Notice').with_foreign_key(:receive_user_id).dependent(:destroy) }
  # it { is_expected.to have_many(:likes) }
  # it { is_expected.to have_many(:like_products).through(:likes).source(:product) }

  # it { is_expected.to validate_presence_of(:email) }
  # it { is_expected.to validate_length_of(:email).is_at_most(50) }
  # it('メールアドレスは正しいフォーマット') do
  #   email = 'ffff.com'
  #   user = build(:user, email: email)
  #   user.valid?
  #   expect(user.errors[:email][0]).to eq('は不正な値です')
  # end

  # it { is_expected.to validate_presence_of(:password) }
  # it { is_expected.to validate_length_of(:password).is_at_least(8).is_at_most(20) }
  # it('パスワードは大文字、小文字、数字全て含む') do
  #   password = 'password1010'
  #   user = build(:user, password: password, password_confirmation: password)
  #   user.valid?
  #   expect(user.errors[:password][0]).to eq('は不正な値です')
  # end

  # it { is_expected.to validate_presence_of(:account_name) }
  # it { is_expected.to validate_length_of(:account_name).is_at_most(20) }

  # it { is_expected.to validate_presence_of(:family_name) }
  # it { is_expected.to validate_length_of(:family_name).is_at_most(20) }

  # it { is_expected.to validate_presence_of(:first_name) }
  # it { is_expected.to validate_length_of(:first_name).is_at_most(20) }

  # it { is_expected.to validate_presence_of(:postal_code) }
  # it('郵便番号は七桁の数値文字列') do
  #   user = build(:user, postal_code: '123-4567')
  #   user.valid?
  #   expect(user.errors[:postal_code][0]).to eq('は不正な値です')

  #   user2 = build(:user, postal_code: '123-456789')
  #   user.valid?
  #   expect(user.errors[:postal_code][0]).to eq('は不正な値です')
  # end

  # it { is_expected.to validate_presence_of(:address) }
  # it { is_expected.to validate_length_of(:address).is_at_most(50) }

  # it { is_expected.to validate_presence_of(:prefecture_id) }
  # it { is_expected.to validate_numericality_of(:prefecture_id).is_greater_than_or_equal_to(1) }
  # it { is_expected.to validate_numericality_of(:prefecture_id).is_less_than_or_equal_to(47) }

  # it { is_expected.to have_secure_password }

  # it('デフォルトスコープがID順') do
  #   user1 = create(:user)
  #   user2 = create(:user)
  #   user3 = create(:user)
  #   expect(User.all).to eq([user1, user2, user3])
  # end

  # it('authenticate?(token, digest_string)メソッド') do
  #   user = build(:user)
  #   session_id = new_token
  #   invalid_token = new_token
  #   user.session_digest = to_digest(session_id)
  #   aggregate_failures do
  #     expect(user.authenticate?(session_id, :session_digest)).to eq(true)
  #     expect(user.authenticate?(invalid_token, :session_digest)).to eq(false)
  #   end
  # end

  # it('ユーザー作成後にactivation_tokenとdigestを作成') do
  #   user = create(:user)
  #   expect(user.reload.authenticate?(user.activation_token, :activation_digest)).to eq(true)
  # end

  # # it('ユーザー作成後にアカウント有効化メールを送信') do
  # #   allow(UserMailer).to receive_message_chain(:send_account_activation_mail, :deliver_now)
  # #   user = create(:user)
  # #   expect(UserMailer).to have_received(:send_account_activation_mail).with(user.reload)
  # # end

  # describe('create_reset_token_and_digest') do
  #   let(:user) { create(:user) }
  #   it('tokenを作成し、インスタンス変数に代入する') do
  #     user.create_reset_token_and_digest
  #     expect(user.reset_token).to be_truthy
  #   end

  #   it('reset_digestを更新') do
  #     user.create_reset_token_and_digest
  #     expect(user.reload.reset_digest).to be_truthy
  #   end

  #   it('reset_tokenとdigestが一致') do
  #     user.create_reset_token_and_digest
  #     expect(user.authenticate?(user.reset_token, :reset_digest)).to eq(true)
  #   end
  # end

  # describe('like?(product)') do
  #   it('商品にいいねしているとtrueを返す') do
  #     user = create(:user)
  #     product = create(:product)
  #     create(:like, user: user, product: product)
  #     expect(user.like?(product)).to eq(true)
  #   end

  #   it('商品にいいねをしていないとfalseを返す') do
  #     user = create(:user)
  #     product = create(:product)
  #     create(:like, user: user)
  #     expect(user.like?(product)).to eq(false)
  #   end
  # end

  # describe('not_received_todos') do
  #   it('ユーザーのtraded:true, solded: falseなtodosの配列を返す') do
  #     user = create(:user)
  #     sell_product = create(:purchace_product, user: user)
  #     create(:purchace_product, user: user, solded: true)
  #     create(:purchace_product, purchace_user: user, solded: true)
  #     purchace_product = create(:purchace_product, purchace_user: user)
  #     Product.all.each do |p|
  #       p.create_todo
  #     end
  #     # 購入した商品2(solded: true, false), 出品した商品2(solded: true, false)
  #     todos = user.not_received_todos

  #     aggregate_failures do
  #       expect(todos.length).to eq(2)
  #       expect(todos[0].id).to eq(purchace_product.id)
  #       expect(todos[1].id).to eq(sell_product.id)
  #     end
  #   end
  # end

  # describe('purchace_products_to_evaluate') do # solded: false && received: true
  #   it('評価すべき商品の配列を返す') do
  #     user = create(:user)
  #     product_to_evaluate = create(:purchace_product, purchace_user: user, solded: false)
  #     create(:todo, product: product_to_evaluate, received: true)
  #     product = create(:purchace_product, purchace_user: user, solded: false)
  #     create(:todo, product: product, received: false)

  #     products = user.purchace_products_to_evaluate
  #     aggregate_failures do
  #       expect(products.length).to eq(1)
  #       expect(products[0].id).to eq(product_to_evaluate.id) 
  #     end
  #   end
  # end

  describe('average_score') do
    let(:user) { create(:user) }
    let(:products_1) { create_list(:product, 3, user: user) }
    let(:products_2) { create_list(:product, 3, user: user) }
    let!(:evaluations_1) do
      products_1.each { |p| create(:evaluation, product: p, score: 1) }
    end
    let!(:evaluations_2) do
      products_2.each { |p| create(:evaluation, product: p, score: 2) }
    end
    it('評価の平均を返す') do
      expect(user.average_score).to eq(1.5)
    end
  end
end
