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
    purchace_user = create(:user)
    sell_user = create(:user)
    product = create(:product, user: sell_user)
    p_p = create(:purchaced_product, product: product)
    expect {
      p_p.update(shipped: true)
    }.to change(p_p.notices, :count).by(1)
  end
end
