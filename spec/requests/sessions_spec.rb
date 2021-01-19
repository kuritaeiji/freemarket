require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe('GET /log_in') do
    it('200レスポンスが返る') do
      get('/log_in')
      expect(response.status).to eq(200)
    end
  end

  describe('POST /log_in') do
    let(:user) { create(:user) }

    context('メールアドレスが間違っている時') do
      let(:invalid_params) { { user: { email: 'ff@ff.com', password: user.password } } }
      it('エラーメッセージが表示される') do
        post('/log_in', params: invalid_params)
        expect(response.body).to include('メールアドレスまたはパスワードが間違っています。')
      end

      it('メールアドレスがフォームに残る') do
        post('/log_in', params: invalid_params)
        expect(response.body).to include('ff@ff.com')
      end
    end

    context('パスワードが間違っている時') do
      let(:invalid_params) { { user: { email: user.email, password: 'pass' } } }
      it('エラーメッセージが表示される') do
        post('/log_in', params: invalid_params)
        expect(response.body).to include('メールアドレスまたはパスワードが間違っています。')
      end
    end

    context('有効な値を送信する時') do
      let(:valid_params) { { user: { email: user.email, password: user.password } } }
      it('ホーム画面にリダイレクトする') do
        post('/log_in', params: valid_params)
        expect(response).to redirect_to(root_path)
      end

      it('クッキーが生成されている') do
        post('/log_in', params: valid_params)
        expect(response.cookies['user_id'].present?).to eq(true)
        expect(user.reload.authenticate?(response.cookies['session_id'])).to eq(true)
      end
    end
  end

  describe('DELETE /log_out') do
    context('ログインしていない時') do
      it('ホーム画面にリダイレクトする') do
        delete('/log_out')
        expect(response).to redirect_to(root_path)
      end
    end

    context('ログインしている時') do
      let(:user) { create(:user) }
      it('クッキーが消える') do
        log_in_request(user)
        delete('/log_out')
        expect(response.cookies['user_id']).to eq(nil)
        expect(response.cookies['session_id']).to eq(nil)
      end

      it('ホーム画面にリダイレクトする') do
        log_in_request(user)
        delete('/log_out')
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
