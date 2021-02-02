require 'rails_helper'

RSpec.describe Todo, type: :model do
  it { is_expected.to belong_to(:purchaced_product) }
end
