require 'rails_helper'

RSpec.describe "Evaluations", type: :request do
  describe('POST /purchaced_products/:purchaced_product_id/evaluations') do
    let(:user) { create(:user) }
    context('ログインしていない時') do
      it('ログイン画面にリダイレクトする') do
        post(purchaced_product_evaluations_path(1))
        expect(response).to redirect_to(log_in_url)
      end
    end

    context('receivedがfalseの時') do
      let(:p_p) { create(:purchaced_product, purchace_user: user) }
      it('ホーム画面にリダイレクトする') do
        log_in_request(user)
        post(purchaced_product_evaluations_path(p_p))
        expect(response).to redirect_to(root_url)
      end
    end

    context('ログインユーザーが購入者でない時') do
      let(:p_p) { create(:purchaced_product, received: true) }
      it('ホーム画面にリダイレクトする') do
        log_in_request(user)
        post(purchaced_product_evaluations_path(p_p))
        expect(response).to redirect_to(root_url)
      end
    end

    context('認可された時') do
      let(:p_p) { create(:purchaced_product, received: true, purchace_user: user) }
      context('有効な値を送信する時') do
        it('評価を作成する') do
          log_in_request(user)
          expect {
            post(purchaced_product_evaluations_path(p_p), params: { evaluation: { score: 2 } })
          }.to change(Evaluation, :count).by(1)
        end
      end

      context('無効な値を送信する時') do
        it('200レスポンスが返る') do
          log_in_request(user)
          post(purchaced_product_evaluations_path(p_p), params: { evaluation: { score: 5 } })
          expect(response.status).to eq(200)
        end
      end
    end
  end
end