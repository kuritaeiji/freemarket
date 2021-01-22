require 'rails_helper'
require('uri')

RSpec.describe "Oauth", type: :request do
  describe('GET /oauth/authorization') do
    it('Google認可サーバーにリダイレクトする') do
      get('/oauth/authorization')
      uri = URI('https://accounts.google.com/o/oauth2/auth')
      uri.query = {
        client_id: ENV['GOOGLE_CLIENT_ID'],
        redirect_uri: 'http://localhost:3000/oauth/callback',
        response_type: 'code',
        scope: ['https://www.googleapis.com/auth/userinfo.profile', 'https://www.googleapis.com/auth/userinfo.email'].join(' ')
      }.to_param
      expect(response).to redirect_to(uri.to_s)
    end
  end

  describe('GET /oauth/callback') do
    let(:client_mock) { double('get_token_client') }
    let(:token_mock) { double('token') }
    let(:response_mock) { double('response') }
    let(:user_info) { JSON.generate({ id: '12345' })}
    let(:code) { 'code' }

    before do
      allow_any_instance_of(OauthController).to receive(:get_token_client).and_return(client_mock)
      allow(client_mock).to receive_message_chain(:auth_code, :get_token).and_return(token_mock)
      allow(token_mock).to receive(:get).and_return(response_mock)
      allow(response_mock).to receive(:body).and_return(user_info)
    end

    it('認可コードを用いて認可サーバーからトークンを受け取る') do
      get('/oauth/callback', params: { code: code })
      expect(client_mock).to have_received(:auth_code)
    end

    it('トークンを用いてエンドユーザーの情報取得') do
      get('/oauth/callback', params: { code: code })
      expect(token_mock).to have_received(:get).with('https://www.googleapis.com/oauth2/v1/userinfo')
    end

    context('ユーザーが存在する時') do
      let!(:user) { create(:user, :with_uid) }
      it('ログインする') do
        get('/oauth/callback', params: { code: code })
        expect(response.cookies['user_id']).to be_truthy
        expect(user.reload.authenticate?(response.cookies['session_id'], :session_digest)).to eq(true)
      end

      it('ホーム画面にリダイレクトする') do
        get('/oauth/callback', params: { code: code })
        expect(response).to redirect_to(root_path)
      end
    end

    context('ユーザーが存在しない時') do
      it('新規作成画面を描写する') do
        get('/oauth/callback', params: { code: code })
        expect(response.status).to eq(200)
      end
    end
  end
end
