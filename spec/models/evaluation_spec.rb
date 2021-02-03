require 'rails_helper'

RSpec.describe Evaluation, type: :model do
  it { is_expected.to belong_to(:product) }
  it { is_expected.to have_many(:notices).dependent(:destroy) }
  it { is_expected.to validate_numericality_of(:score).only_integer.is_greater_than_or_equal_to(1)
    .is_less_than_or_equal_to(3) }
  it { is_expected.to validate_presence_of(:score) }

  # it('評価すると、お知らせを作成') do
  #   p_p = create(:purchaced_product)
  #   expect {
  #     p_p.create_evaluation(score: 1)
  #   }.to change(Notice, :count).by(1)
  # end

  # describe('notice_path') do
  #   it('#を返す') do
  #     evaluation = create(:evaluation)
  #     expect(evaluation.notice_path).to eq('#')
  #   end
  # end

  # describe('notice_image') do
  #   it('商品画像の一枚目を返す') do
  #     p_p = create(:purchaced_product)
  #     evaluation = create(:evaluation, purchaced_product: p_p)
  #     expect(evaluation.notice_image).to eq(p_p.images[0])
  #   end
  # end

  # describe('notice_body') do
  #   it('お知らせの本文を返す') do
  #     evaluation = create(:evaluation)
  #     expect(evaluation.notice_body).to eq("#{evaluation.purchaced_product.purchace_user.account_name}が#{evaluation.purchaced_product.name}に「悪い」と評価しました。")
  #   end
  # end
end
