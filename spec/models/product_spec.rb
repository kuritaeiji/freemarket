require 'rails_helper'

RSpec.describe Product, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:shipping_day) }
  it { is_expected.to belong_to(:status) }
  it { is_expected.to belong_to(:category) }

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
    let!(:products) { create_list(:product, 5, category: category, status: status, shipping_day: shipping_day, user: user) }

    it('商品をとってくる') do
      expect(Product.search_by_keywords('商品1')[0]).to eq(Product.find(1))
    end
  end
end
