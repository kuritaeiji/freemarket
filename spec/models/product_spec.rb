require 'rails_helper'

RSpec.describe Product, type: :model do
  it { is_expected.to belong_to(:user) }
  it('alias_method(:sell_user, :user') do
    product = create(:product)
    expect(product.sell_user).to eq(product.user)
  end
  it { is_expected.to belong_to(:purchace_user).class_name('User').optional }
  it { is_expected.to belong_to(:shipping_day) }
  it { is_expected.to belong_to(:status) }
  it { is_expected.to belong_to(:category) }
  it { is_expected.to have_many(:messages) }
  it { is_expected.to have_many(:likes).dependent(:destroy) }
  it { is_expected.to have_many(:like_users).through(:likes).source(:user) }
  it { is_expected.to have_one(:todo).dependent(:destroy) }
  it { is_expected.to have_one(:evaluation).dependent(:destroy) }

  it('Messageableモジュールをインクルードする') do
    expect(Product.include?(Messageable)).to eq(true)
  end

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_most(50) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_length_of(:description).is_at_most(300) }

  describe('商品画像のバリデーション') do
    it('画像が存在しない時バリデーションエラー') do
      product = build(:product, images: [])
      product.valid?
      expect(product.errors[:images]).to include('を添付して下さい')
    end

    it('画像以外が添付されている時バリデーションエラー') do
      product = build(:product, images: [fixture_file_upload("#{Rails.root}/spec/models/user_spec.rb")])
      product.valid?
      expect(product.errors[:images]).to include('には画像を添付して下さい')
    end

    it('2MBより大きいファイルの時バリデーションエラー') do
      product = build(:product, images: [fixture_file_upload("#{Rails.root}/spec/images/false_image.dmg")])
      product.valid?
      expect(product.errors[:images]).to include('は2MB以内')
    end
  end

  describe('search_by_keywords(keywords)') do
    let(:category) { create(:category) }
    let(:status) { create(:status) }
    let(:shipping_day) { create(:shipping_day) }
    let(:user) { create(:user) }
    let!(:product) { create(:product, name: 'テストプロダクト', category: category, status: status, shipping_day: shipping_day, user: user)}
    let!(:products) { create_list(:product, 5, category: category, status: status, shipping_day: shipping_day, user: user) }

    it('商品をとってくる') do
      expect(Product.search_by_keywords('テストプロダクト')[0]).to eq(Product.find(1))
    end
  end

  describe('self.as_json(products)') do
    let(:products) { create_list(:product, 5) }
    it('商品情報ハッシュの入った配列を返す') do
      products_as_json = Product.as_json(products)
      aggregate_failures do
        expect(products_as_json.length).to eq(5)
        expect(products_as_json[0][:id]).to eq(products[0].id)
        expect(products_as_json[0][:name]).to eq(products[0].name)
        expect(products_as_json[0][:url]).to eq("/products/#{products[0].id}")
      end
    end

    it('商品画像をbase64エンコードした文字列を持つ') do
      products_as_json = Product.as_json(products)
      base64_image = products[0].images.blobs[0].open do |f|
        'data:image/png;base64,' + Base64.encode64(f.read)
      end
      expect(products_as_json[0][:image]).to eq(base64_image)
    end
  end

  describe('set_image_as_base64(index)') do
    let(:product) { create(:product) }
    it('index番号目の商品画像をbase64エンコードした文字列をimageインスタンス変数に代入する') do
      product.set_image_as_base64(0)
      base64_image = product.images.blobs[0].open do |f|
        'data:image/png;base64,' + Base64.encode64(f.read)
      end
      expect(product.image).to eq(base64_image)
    end
  end

  describe('after_update_commit(:destroy_likes)') do
    context('商品を購入してtraded: trueに更新する時') do
      it('商品へのいいねが削除される') do
        product = create(:product)
        likes = create_list(:like, 2, product: product)
        expect {
          product.update(traded: true)
        }.to change(product.likes, :count).by(-2)
      end
    end

    context('他のカラムを更新するとき') do
      it('商品へのいいねが削除されない') do
        product = create(:product)
        likes = create_list(:like, 2, product: product)
        expect {
          product.update(name: 'テスト')
        }.not_to change(product.likes, :count)
      end
    end
  end

  describe('can_send_message?') do
    it('まだ取引されていない時trueを返す') do
      product_mock = double('Product')
      allow(product_mock).to receive(:traded?).and_return(false)
      allow(product_mock).to receive(:can_send_message?).and_return(!product_mock.traded?)
      expect(product_mock.can_send_message?('a')).to eq(true)
    end

    it('すでに取引されている時falseを返す') do
      product_mock = double('Product')
      allow(product_mock).to receive(:traded?).and_return(true)
      allow(product_mock).to receive(:can_send_message?).and_return(!product_mock.traded?)
      expect(product_mock.can_send_message?('a')).to eq(false)
    end
  end

  describe('create_notice(message)') do
    let(:user) { create(:user) }
    context('メッセージユーザーが出品者である時') do
      let!(:product) { create(:product, user: user) }
      let!(:other_user) { create(:user) }
      let!(:message1) { create(:message, user: other_user, messageable: product) }
      let!(:message2) { create(:message, user: other_user, messageable: product) }
      let!(:messages) { create_list(:message, 2, messageable: product) }
      it('これまでにメッセージを送ってきたユーザー全員にお知らせを作成する') do
        expect {
          sell_user_message = create(:message, user: user, messageable: product)
        }.to change(Notice, :count).by(3)
        notices = other_user.receive_notices
        expect(notices.length).to eq(1)
        expect(notices[0].send_user).to eq(user)
      end
    end

    context('メッセージユーザーが出品者以外である時') do
      let!(:product) { create(:product, user: user) }
      it('出品者に対するお知らせを作成する') do
        expect {
          create(:message, messageable: product)
        }.to change(user.receive_notices, :count).by(1)
        notice = user.receive_notices[0]
        expect(notice.send_user).to eq(Message.first.user)
      end
    end
  end

  describe('notice_messgeable_body(message)') do
    it('商品のメッセージに対するお知らせの本文を返す') do
      product = create(:product)
      message = create(:message, messageable: product)
      expect(product.notice_messageable_body(message)).to eq("#{message.user.account_name}が#{product.name}にメッセージを送りました。")
    end
  end

  describe('notice_messageable_image') do
    it('商品画像の一枚目を返す') do
      product = create(:product)
      expect(product.notice_messageable_image).to eq(product.images[0])
    end
  end

  describe('notice_messageable_path') do
    it('商品詳細ページのパスを返す') do
      product = create(:product)
      expect(product.notice_messageable_path).to eq("/products/#{product.id}")
    end
  end
end
