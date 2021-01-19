require 'rails_helper'

RSpec.describe Prefecture, type: :model do
  it { is_expected.to have_many(:users) }
  
  it('デフォルトスコープがID順') do
    p1 = create(:prefecture)
    p2 = create(:prefecture)
    p3 = create(:prefecture)
    expect(Prefecture.all).to eq([p1, p2, p3])
  end
end
