require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe('GET /users/new') do
    it('200レスポンスが返る') do
      get('/users/new')
      expect(response.status).to eq(200)
    end
  end

  describe('POST /users') do
    context('有効なパラメーターを送信する時') do
      let(:valid_params) { attributes_for(:user, :valid_params) }

      it('ユーザーを作成できる') do
        expect {
          post('/users', params: { user: valid_params })
        }.to change(User, :count).by(1)
      end

      it('画像を添付できる') do
        expect {
          post('/users', params: { user: valid_params })
        }.to change(ActiveStorage::Attachment, :count).by(1)
      end

      it('ホーム画面にリダイレクトする') do
        post('/users', params: { user: valid_params })
        expect(response).to redirect_to(root_path)
      end
    end

    context('無効なパラメーターを送信する時') do
      let(:invalid_params) { attributes_for(:user, :invalid_params) }

      it('ユーザーを作成できない') do
        expect {
          post('/users', params: { user: invalid_params })
        }.not_to change(User, :count)
      end

      it('新規登録画面を描画') do
        post('/users', params: { user: invalid_params })
        aggregate_failures do
          expect(response.body).to include('新規登録')
          expect(response.body).to include('エラーがあります')
        end
      end
    end
  end
end
