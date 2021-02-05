require 'rails_helper'

RSpec.describe PurchacedProduct, type: :model do
  it { is_expected.to belong_to(:purchace_user).class_name('User') }
  it { is_expected.to belong_to(:product) }
  it { is_expected.to have_many(:notices).dependent(:destroy) }
  it { is_expected.to have_one(:evaluation).dependent(:destroy) }
  it { is_expected.to have_many(:messages).dependent(:destroy) }

  it { is_expected.to delegate_method(:user).to(:product).with_prefix(:sell) }
  it { is_expected.to delegate_method(:name).to(:product) }
  it { is_expected.to delegate_method(:description).to(:product) }
  it { is_expected.to delegate_method(:category).to(:product) }
  it { is_expected.to delegate_method(:shipping_day).to(:product) }
  it { is_expected.to delegate_method(:status).to(:product) }
  it { is_expected.to delegate_method(:images).to(:product) }

  it('購入された商品を作成すると商品のtradedカラムをtrueにする') do
    product = create(:product)
    p_p = create(:purchaced_product, product: product)
    expect(product.reload.traded?).to eq(true)
  end

  it('購入された商品のreceivedをtrueに更新すると商品のsoldedカラムをtrueに更新する') do
    product = create(:product)
    p_p = create(:purchaced_product, product: product)
    p_p.update(received: true)
    expect(product.reload.solded?).to eq(true)
  end

  it('shippedをtrueに更新するとお知らせを作成する') do
    sell_user = create(:user)
    product = create(:product, user: sell_user)
    p_p = create(:purchaced_product, product: product)
    expect {
      p_p.update(shipped: true)
    }.to change(p_p.notices, :count).by(1)
  end

  it('shippedをtrueに更新すると「荷物を発送しました。」というメッセージを作成') do
    product = create(:product)
    p_p = create(:purchaced_product, product: product)
    expect {
      p_p.update(shipped: true)
    }.to change(p_p.messages, :count).by(1)
    expect(p_p.messages[-1].content).to eq('荷物を発送しました。')
  end

  describe('notice_path') do
    it('購入済み商品詳細画面を返す') do
      p_p = create(:purchaced_product)
      path = "/purchaced_products/#{p_p.id}"
      expect(p_p.notice_path).to eq(path)
    end
  end

  describe('notice_body') do
    it('お知らせの本文を返す') do
      p_p = create(:purchaced_product)
      expect(p_p.notice_body).to eq("#{p_p.sell_user}が#{p_p.name}を発送しました。")
    end
  end

  describe('notice_image') do
    it('商品の画像の一枚目を返す') do
      p_p = create(:purchaced_product)
      expect(p_p.notice_image).to eq(p_p.images[0])
    end
  end
end
