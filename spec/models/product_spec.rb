require 'rails_helper'

RSpec.describe Product, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:shipping_day) }
  it { is_expected.to belong_to(:status) }
  it { is_expected.to belong_to(:category) }
end
