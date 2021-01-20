require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do
  describe('POST /password_resets') do
    let(:user) { create(:user) }
    context('ユーザーが存在する時') do
      it('reset_tokenとreset_digestを作成してユーザーを更新する') do
        post('/password_resets', params: { user: { email: user.email } })
        expect(user.reload.authenticate?(user.reset_token, :reset_digest)).to eq(true)
      end

      it('メールを送信する') do
        allow(UserMailer).to receive_message_chain(:send_password_reset_mail, :deliver_now)
        post('/password_resets', params: { user: { email: user.email } })
        expect(UserMailer).to have_received(:send_password_reset_mail).with(user.reload)
      end

      it('ホーム画面にリダイレクトする') do
        post('/password_resets', params: { user: { email: user.email } })
        expect(response).to redirect_to(root_url)
      end
    end

    context('ユーザーが存在しない時') do
      let(:invalid_email) { 'invalid_email' }
      it('フォームにemailが入っている') do
        post('/password_resets', params: { user: { email: invalid_email } })
        expect(response.body).to include(invalid_email)
      end

      it('フラッシュメッセージが表示') do
        post('/password_resets', params: { user: { email: invalid_email } })
        expect(response.body).to include('メールアドレスが間違っています。')
      end
    end
  end

  describe('GET /password_resets/:id/edit') do
    let(:user) { create(:user) }
    context('ユーザーが存在しない時') do
      it('ホーム画面にリダイレクトする') do
        get("/password_resets/#{'a'}/edit", params: { reset_token: user.reset_token })
        expect(response).to redirect_to(root_url)
      end
    end

    context('reset_tokenが正しくない時') do
      it('ホーム画面にリダイレクトする') do
        get("/password_resets/#{user.id}/edit", params: { reset_token: 'invalid_token' })
        expect(response).to redirect_to(root_url)
      end
    end

    context('ユーザーが有効化されていない時') do
      it('ホーム画面にリダイレクトする') do
        user = create(:user, activated: false)
        get("/password_resets/#{user.id}/edit", params: { reset_token: user.reset_token })
        expect(response).to redirect_to(root_url)
      end
    end

    context('正しいユーザーの時') do
      it('200レスポンスを返す') do
        get("/password_resets/#{user.id}/edit", params: { reset_token: user.reset_token })
        expect(response.status).to eq(200)
      end
    end
  end

  describe('PUT /password_resets/:id') do
    let(:user) { create(:user) }
    context('ユーザーが存在しない時') do
      it('ホーム画面にリダイレクトする') do
        put("/password_resets/#{'a'}", params: { reset_token: user.reset_token })
        expect(response).to redirect_to(root_url)
      end
    end

    context('reset_tokenが正しくない時') do
      it('ホーム画面にリダイレクトする') do
        put("/password_resets/#{user.id}", params: { reset_token: 'invalid_token' })
        expect(response).to redirect_to(root_url)
      end
    end

    context('ユーザーが有効化されていない時') do
      it('ホーム画面にリダイレクトする') do
        user = create(:user, activated: false)
        put("/password_resets/#{user.id}", params: { reset_token: user.reset_token })
        expect(response).to redirect_to(root_path)
      end
    end

    context('正しいユーザーの時') do
      let(:password) { 'Password1111' }
      context('有効なパスワードの時') do
        it('ユーザーを更新する') do
          put("/password_resets/#{user.id}", params: { user: { password: password, password_confirmation: password }, reset_token: user.reset_token })
          expect(user.reload.authenticate?(password, :password_digest)).to eq(true)
        end

        it('ログイン画面にリダイレクトする') do
          put("/password_resets/#{user.id}", params: { user: { password: password, password_confirmation: password }, reset_token: user.reset_token })
          expect(response).to redirect_to(log_in_path)
        end
      end

      context('無効なパスワードの時') do
        it('パスワード設定画面を描写する') do
          put("/password_resets/#{user.id}", params: { user: { password: '', password_confirmation: '' }, reset_token: user.reset_token })
          expect(response.body).to include('パスワードを入力してください')
        end
      end
    end
  end
end
