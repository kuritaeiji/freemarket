require 'rails_helper'
include(SessionsHelper)

RSpec.describe "AccountActivations", type: :request do
  describe('edit') do
    context('有効化できない時') do
      it('無効なユーザーIDだとホーム画面にリダイレクトする') do
        user = create(:user)
        get('/account_activate', params: { user_id: 'a' })
        expect(response).to redirect_to(root_url)
      end
  
      it('すでに有効化されているとホーム画面にリダイレクトする') do
        user = create(:user)
        get('/account_activate', params: { user_id: user.id })
        expect(response).to redirect_to(root_url)
      end
  
      it('無効なトークンだとホーム画面にリダイレクトする') do
        user = create(:user, activated: false, activation_digest: to_digest(new_token))
        get('/account_activate', params: { user_id: user.id, activation_token: 'invalid token' })
        expect(response).to redirect_to(root_url)
      end
    end
    
    context('有効化できた時') do
      let(:user) { create(:user, activated: false) }
      it('有効化される') do
        get('/account_activate', params: { user_id: user.id, activation_token: user.activation_token })
        expect(user.reload.activated?).to eq(true)
      end

      it('ログインする') do
        get('/account_activate', params: { user_id: user.id, activation_token: user.activation_token })
        expect(response.cookies['user_id']).to be_truthy
        expect(response.cookies['session_id']).to be_truthy
      end

      it('ホーム画面にリダイレクトする') do
        get('/account_activate', params: { user_id: user.id, activation_token: user.activation_token })
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
