require 'rails_helper'

RSpec.describe Like, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:product) }
  it { is_expected.to have_many(:notices).dependent(:destroy) }

  describe('after_create_commit') do
    it('お知らせを作成する') do
      user = create(:user)
      product = create(:product)

      expect {
        create(:like, user: user, product: product)
      }.to change(Notice, :count).by(1)
    end
  end

  describe('after_destroy') do
    it('お知らせを削除する') do
      user = create(:user)
      product = create(:product)
      like = create(:like, user: user, product: product)
      notice = create(:like_notice, send_user: user, receive_user: product.user, noticeable: like)

      like.destroy
      expect(Notice.find_by(id: notice.id)).to eq(nil)
    end
  end
end
