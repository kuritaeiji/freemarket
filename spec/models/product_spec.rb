require 'rails_helper'

RSpec.describe Product, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:shipping_day) }
  it { is_expected.to belong_to(:status) }
  it { is_expected.to belong_to(:category) }

  describe('order_by_option(option)') do
    let(:category) { create(:category) }
    let(:status) { create(:status) }
    let(:shipping_day) { create(:shipping_day) }
    let!(:products) { create_list(:product, 5, category: category, status: status, shipping_day: shipping_day) }

    it('価格の安い順') do
      expect(Product.all.order_by_option('1')).to eq(Product.all.order(price: :asc))
    end

    it('価格の高い順') do
      expect(Product.all.order_by_option('2')).to eq(Product.all.order(price: :desc))
    end

    it('順番を選択しない時新しい順') do
      expect(Product.all.order_by_option('')).to eq(Product.all.order(created_at: :desc))
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
