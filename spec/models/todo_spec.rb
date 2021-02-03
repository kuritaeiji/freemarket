require 'rails_helper'

RSpec.describe Todo, type: :model do
  it { is_expected.to belong_to(:product) }
  it { is_expected.to have_many(:messages).dependent(:destroy) }
  it { is_expected.to have_many(:notices).dependent(:destroy) }
end
