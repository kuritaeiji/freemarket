require 'rails_helper'

RSpec.describe "Products", type: :request do
  describe('POST /products') do
    context('ログインしていない時') do
      it('ログイン画面にリダイレクトする') do
        post('/products')
        expect(response).to redirect_to(log_in_path)
      end
    end

    context('認証された時') do
      let(:user) { create(:user) }
      before do
        log_in_request(user)
      end

      context('有効な値を送信する時') do
        let(:valid_params) { { product: attributes_for(:product, :valid_params) } }

        it('商品を作成する') do
          expect {
            post('/products', params: valid_params)
          }.to change(Product, :count).by(1)
        end

        it('商品詳細画面にリダイレクトする') do
          post('/products', params: valid_params)
          expect(response).to redirect_to(product_path(Product.last.id))
        end
      end

      context('無効な値を送信する時') do
        let(:invalid_params) { { product: attributes_for(:product, :invalid_params) } }
        it('商品を作成しない') do
          expect {
            post('/products', params: invalid_params)
          }.not_to change(Product, :count)
        end

        it('200レスポンスが返る') do
          post('/products', params: invalid_params)
          expect(response.status).to eq(200)
        end
      end
    end
  end

  describe('PUT /products/:id') do
    let(:user) { create(:user) }
    let(:product) { create(:product, user: user) }
    context('ログインしていない時') do
      it('ログイン画面にリダイレクトする') do
        put(product_path(product.id))
        expect(response).to redirect_to(log_in_path)
      end
    end

    context('正しいユーザーではない時') do
      let(:other_user) { create(:user) }

      it('ホーム画面にリダイレクトする') do
        log_in_request(other_user)
        put(product_path(product.id))
        expect(response).to redirect_to(root_url)
      end
    end

    context('取引中の商品を更新しようとする時') do
      let(:traded_product) { create(:product, traded: true) }
      it('ホーム画面にリダイレクトする') do
        log_in_request(user)
        put(product_path(traded_product.id))
        expect(response).to redirect_to(root_url)
      end
    end

    context('認可された時') do
      context('有効な値を送信する時') do
        let(:valid_params) { { product: attributes_for(:product, :valid_params, name: '更新された商品') } }
        it('商品を更新する') do
          log_in_request(user)
          put(product_path(product.id), params: valid_params)
          expect(product.reload.name).to eq('更新された商品')
        end
      end

      context('無効な値を送信する時') do
        let(:invalid_params) { { product: attributes_for(:product, :invalid_params) } }
        it('商品を更新しない') do
          log_in_request(user)
          put(product_path(product.id), params: invalid_params)
          expect(product).to eq(product.reload)
        end
      end
    end
  end
end
