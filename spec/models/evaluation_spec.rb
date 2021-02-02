require 'rails_helper'

RSpec.describe Evaluation, type: :model do
  it { is_expected.to belong_to(:purchaced_product) }
  it { is_expected.to have_many(:notices).dependent(:destroy) }
  it { is_expected.to validate_numericality_of(:score).only_integer.is_greater_than_or_equal_to(1)
    .is_less_than_or_equal_to(3) }
  it { is_expected.to validate_presence_of(:score) }

  it('評価すると、お知らせを作成') do
    p_p = create(:purchaced_product)
    expect {
      p_p.create_evaluation(score: 1)
    }.to change(Notice, :count).by(1)
  end
end
