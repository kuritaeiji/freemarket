require 'rails_helper'

RSpec.describe ShippingDay, type: :model do
  it { is_expected.to have_many(:products) }
end
