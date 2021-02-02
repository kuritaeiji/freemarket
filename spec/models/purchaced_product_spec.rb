require 'rails_helper'

RSpec.describe PurchacedProduct, type: :model do
  it { is_expected.to belong_to(:purchace_user).class_name('User') }
  it { is_expected.to belong_to(:product) }
  it { is_expected.to have_one(:todo) }

  it { is_expected.to delegate_method(:user).to(:product).with_prefix(:sell) }
  it { is_expected.to delegate_method(:name).to(:product) }
  it { is_expected.to delegate_method(:description).to(:product) }
  it { is_expected.to delegate_method(:category).to(:product) }
  it { is_expected.to delegate_method(:shipping_day).to(:product) }
  it { is_expected.to delegate_method(:status).to(:product) }
  it { is_expected.to delegate_method(:images).to(:product) }
end
