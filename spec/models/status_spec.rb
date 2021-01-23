require 'rails_helper'

RSpec.describe Status, type: :model do
  it { is_expected.to have_many(:products) }
end
