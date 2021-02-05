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

  describe('notice_path') do
    it('いいねした商品の詳細画面のパスを返す') do
      product = create(:product)
      like = create(:like, product: product)
      path = "/products/#{product.id}"
      expect(like.notice_path).to eq(path)
    end
  end

  describe('notice_image') do
    it('いいねした商品の画像1枚目を返す') do
      product = create(:product)
      like = create(:like, product: product)
      expect(like.notice_image).to eq(product.images[0])
    end
  end

  describe('notice_body') do
    it('お知らせの本文を返す') do
      like = create(:like)
      expect(like.notice_body).to eq("#{like.user.account_name}が#{like.product.name}にいいね！しました。")
    end
  end
end
