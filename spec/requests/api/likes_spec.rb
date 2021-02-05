require 'rails_helper'

RSpec.describe "Api::Likes", type: :request do
  # describe('POST /products/:product_id/likes') do
  #   let(:user) { create(:user) }
  
  #   context('ログインしていない場合') do
  #     it('ログイン画面にリダイレクトする') do
  #       post(api_product_likes_path(1))
  #       expect(response).to redirect_to(log_in_path)
  #     end
  #   end

  #   context('出品者である場合') do
  #     let(:product) { create(:product, user: user) }
  #     it('ホーム画面にリダイレクトする') do
  #       log_in_request(user)
  #       post(api_product_likes_path(product.id))
  #       expect(response).to redirect_to(root_url)
  #     end
  #   end

  #   context('商品が取引済みである場合') do
  #     let(:product) { create(:product, traded: true) }
  #     it('ホーム画面にリダイレクトする') do
  #       log_in_request(user)
  #       expect {
  #         post(api_product_likes_path(product.id))
  #       }.not_to change(Like, :count)
  #       expect(response).to redirect_to(root_url)
  #     end
  #   end

  #   context('認可されたユーザーの場合') do
  #     let(:product) { create(:product) }
  #     it('いいねを作成できる') do
  #       log_in_request(user)
  #       expect {
  #         post(api_product_likes_path(product.id))
  #       }.to change(user.likes, :count).by(1)
  #     end

  #     it('jsonを返す') do
  #       log_in_request(user)
  #       post(api_product_likes_path(product.id))
  #       json = JSON.parse(response.body)
  #       expect(json['status']).to eq(200)
  #     end
  #   end
  # end

  describe('DELETE /products/:product_id/like') do
    context('ログインしていない場合') do
      it('ログイン画面にリダイレクトする') do
        delete(api_product_like_path(1))
        expect(response).to redirect_to(log_in_path)
      end
    end

    context('いいねの所有者でない場合') do
      let(:user) { create(:user) }
      let(:product) { create(:product) }
      let!(:like) { create(:like, product: product) }
      it('ホーム画面にリダイレクトする') do
        log_in_request(user)
        delete(api_product_like_path(product.id))
        expect(response).to redirect_to(root_path)
      end
    end

    context('認可されたユーザーの場合') do
      let(:user) { create(:user) }
      let(:product) { create(:product) }
      let!(:like) { create(:like, product: product, user: user) }
      it('いいねを削除できる') do
        log_in_request(user)
        delete(api_product_like_path(product.id))
        expect(Like.count).to eq(0)
      end

      it('jsonを返す') do
        log_in_request(user)
        delete(api_product_like_path(product.id))
        json = JSON.parse(response.body)
        expect(json['status']).to eq(200)
      end
    end
  end
end
