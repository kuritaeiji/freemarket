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

  describe('GET /users/:id/edit') do
    context('ログインしていない時') do
      it('ログイン画面にリダイレクトする') do
        get(edit_user_path('a'))
        expect(response).to redirect_to(log_in_path)
      end
    end

    context('正しいユーザーでない時') do
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }
      it('ホーム画面にリダイレクトする') do
        log_in_request(user)
        get(edit_user_path(other_user))
        expect(response).to redirect_to(root_url)
      end
    end

    context('正しいユーザーでログインしている時') do
      let(:user) { create(:user) }
      it('200レスポンスが返る') do
        log_in_request(user)
        get(edit_user_path(user))
        expect(response.status).to eq(200)
      end
    end
  end

  describe('PUT /users/:id') do
    context('ログインしていない時') do
      it('ログイン画面にリダイレクトする') do
        put(user_path('a'))
        expect(response).to redirect_to(log_in_path)
      end
    end

    context('正しいユーザーでない時') do
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }
      it('ホーム画面にリダイレクトする') do
        log_in_request(user)
        put(user_path(other_user))
        expect(response).to redirect_to(root_path)
      end
    end

    context('正しいユーザーでログインしている時') do
      let(:user) { create(:user) }
      context('有効な値を送信する時') do
        let(:valid_params) { attributes_for(:user, account_name: 'account') }
        it('ユーザーが更新される') do
          log_in_request(user)
          put(user_path(user), params: { user:  valid_params })
          expect(user.reload.account_name).to eq('account')
        end

        it('マイページにリダイレクトする') do
          log_in_request(user)
          put(user_path(user), params: { user: valid_params })
          expect(response).to redirect_to(user_path(user))
        end
      end

      context('不正な値を送信する時') do
        let(:invalid_params) { attributes_for(:user, account_name: nil) }
        it('ユーザーが更新されない') do
          log_in_request(user)
          put(user_path(user), params: { user: invalid_params })
          expect(user.reload).to eq(user)
        end

        it('200レスポンスが返る') do
          log_in_request(user)
          put(user_path(user), params: { user: invalid_params })
          expect(response.status).to eq(200)
        end
      end
    end
  end

  describe('POST /users/oauth') do
    context('uidを送信していない時') do
      let(:valid_params) { attributes_for(:user) }
      it('ログイン画面にリダイレクトする') do
        post(oauth_users_path, params: { user: valid_params })
        expect(response).to redirect_to(root_path)
      end
    end

    context('uidを送信する時') do
      context('有効な値を送信する時') do
        let(:valid_params) { attributes_for(:user, :with_uid).merge(prefecture_id: create(:prefecture).id) }
        it('ユーザーを作成できる') do
          expect { 
            post(oauth_users_path, params: { user: valid_params })
          }.to change(User, :count).by(1)
        end

        it('ログインする') do
          post(oauth_users_path, params: { user: valid_params })
          expect(User.last.authenticate?(response.cookies['session_id'], :session_digest)).to eq(true)
        end

        it('ホーム画面にリダイレクトする') do
          post(oauth_users_path, params: { user: valid_params })
          expect(response).to redirect_to(root_path)
        end
      end

      context('無効な値を送信する時') do
        let(:invalid_params) { attributes_for(:user, :with_uid, account_name: nil) }
        it('ユーザーを作成しない') do
          expect {
            post(oauth_users_path, params: { user: invalid_params })
          }.not_to change(User, :count)
        end
      end
    end
  end
end
