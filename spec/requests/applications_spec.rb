require 'rails_helper'

RSpec.describe "Applications", type: :request do
  describe('GET /') do
    let(:user) { create(:user) }
    context('ログインしており、評価すべき商品が存在する場合') do
      let(:product) { create(:purchace_product, purchace_user: user, solded: false) }
      let!(:todo) { create(:todo, product: product, received: true ) }
      it('評価ページにリダイレクトする') do
        log_in_request(user)
        get(root_path)
        expect(response).to redirect_to(new_product_evaluation_url(product))
      end
    end
  end
end
