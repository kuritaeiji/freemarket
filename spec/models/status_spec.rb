require 'rails_helper'

RSpec.describe Status, type: :model do
  it { is_expected.to have_many(:products) }

  it('cleaner_test') do
    status = create(:status)
    expect(status.id).to eq(1)
  end

  it('cleaner_test') do
    status = create(:status)
    expect(status.id).to eq(1) 
  end
end