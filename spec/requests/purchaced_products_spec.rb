require 'rails_helper'

RSpec.describe "PurchacedProducts", type: :request do
  describe('GET /purchaced_products/:id') do
    context('ログインしていない場合') do
      it('ログイン画面にリダイレクトする') do
        get(purchaced_product_path(1))
        expect(response).to redirect_to(log_in_path)
      end
    end

    context('すでに取引が終了した商品であるとき') do
      it('ホーム画面にリダイレクトする。') do
        user = create(:user)
        p_p = create(:purchaced_product, purchace_user: user, received: true)
        log_in_request(user)
        get(purchaced_product_path(p_p))
        expect(response).to redirect_to(root_path)
      end
    end

    context('ログインユーザーが出品者でも購入者でもないとき') do
      it('ホーム画面にリダイレクトする') do
        user = create(:user)
        p_p = create(:purchaced_product)
        log_in_request(user)
        get(purchaced_product_path(p_p))
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe('POST /products/:product_id/purchaced_products') do
    context('ログインしていない場合') do
      it('ログイン画面にリダイレクトする') do
        post(product_purchaced_products_path(1))
        expect(response).to redirect_to(log_in_path)
      end
    end

    context('商品がすでに取引されている場合') do
      it('ホーム画面にリダイレクトする') do
        user = create(:user)
        product = create(:product, traded: true)
        log_in_request(user)
        post(product_purchaced_products_path(product.id))
        expect(response).to redirect_to(root_path)
      end
    end

    context('認可された場合') do
      let(:user) { create(:user) }
      let(:product) { create(:product) }

      it('購入された商品を作成する') do
        log_in_request(user)
        expect {
          post(product_purchaced_products_path(product.id))
        }.to change(user.purchaced_products, :count).by(1)
      end

      it('購入された商品詳細画面にリダイレクトする') do
        log_in_request(user)
        post(product_purchaced_products_path(product.id))
        expect(response).to redirect_to(purchaced_product_path(PurchacedProduct.first))
      end
    end
  end

  describe('PUT /purchaced_products/:id/ship') do
    let(:user) { create(:user) }
    context('ログインしていない場合') do
      it('ログイン画面にリダイレクトする') do
        put(ship_purchaced_product_path(1))
        expect(response).to redirect_to(log_in_path)
      end
    end

    context('shippedがtrueの場合') do
      let(:product) { create(:product, user: user) }
      let(:p_p) { create(:purchaced_product, product: product, shipped: true) }
      it('ホーム画面にリダイレクトする') do
        log_in_request(user)
        put(ship_purchaced_product_path(p_p))
        expect(response).to redirect_to(root_path)
      end
    end

    context('ログインユーザーがsell_userではない場合') do
      let(:product) { create(:product) }
      let(:p_p) { create(:purchaced_product, product: product) }
      it('ホーム画面にリダイレクトする') do
        log_in_request(user)
        put(ship_purchaced_product_path(p_p))
        expect(response).to redirect_to(root_path)
      end
    end

    context('認可された場合') do
      let(:product) { create(:product, user: user) }
      let(:p_p) { create(:purchaced_product, product: product) }

      it('shippedをtrueに更新する') do
        log_in_request(user)
        put(ship_purchaced_product_path(p_p))
        expect(p_p.reload.shipped?).to eq(true)
      end

      it('購入された商品詳細画面にリダイレクトする') do
        log_in_request(user)
        put(ship_purchaced_product_path(p_p))
        expect(response).to redirect_to(purchaced_product_path(p_p))
      end
    end
  end

  describe('PUT /purchaced_products/:id/receive') do
    let(:user) { create(:user) }
    context('ログインしていない時') do
      it('ログイン画面にリダイレクトする') do
        put(receive_purchaced_product_path(1))
        expect(response).to redirect_to(log_in_path)
      end
    end

    context('receivedがtrueの時') do
      let(:p_p) { create(:purchaced_product, purchace_user: user, received: true) }
      it('ホーム画面にリダイレクトする') do
        log_in_request(user)
        put(receive_purchaced_product_path(p_p))
        expect(response).to redirect_to(root_path)
      end
    end

    context('ログインユーザーが購入者でない時') do
      let(:p_p) { create(:purchaced_product) }
      it('ホーム画面にリダイレクトする') do
        log_in_request(user)
        put(receive_purchaced_product_path(p_p))
        expect(response).to redirect_to(root_path)
      end
    end

    context('認可された時') do
      let(:p_p) { create(:purchaced_product, purchace_user: user) }
      it('receivedをtrueに更新する') do
        log_in_request(user)
        put(receive_purchaced_product_path(p_p))
        expect(p_p.reload.received?).to eq(true)
      end

      it('評価ページにリダイレクトする') do
        log_in_request(user)
        put(receive_purchaced_product_path(p_p))
        expect(response).to redirect_to(new_purchaced_product_evaluation_path(p_p))
      end
    end
  end
end
