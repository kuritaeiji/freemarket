require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  let(:user) { create(:user) }
  describe('log_in(user)') do
    it('user_idクッキーを作成する') do
      helper.log_in(user)
      expect(helper.cookies['user_id'].present?).to eq(true)
    end

    it('ユーザーのsession_digestを更新') do
      helper.log_in(user)
      expect(user.reload.session_digest.present?).to eq(true)
    end

    it('session_idクッキーを作成する') do
      helper.log_in(user)
      aggregate_failures do
        expect(helper.cookies['session_id'].present?).to eq(true)
        expect(user.reload.authenticate?(helper.cookies['session_id'])).to eq(true)
      end
    end
  end

  describe('current_user') do
    context('ログインしている時') do
      it('カレントユーザーを返す') do
        helper.log_in(user)
        expect(helper.current_user).to eq(user.reload)
      end
    end

    context('ログインしていない時') do
      it('nilを返す') do
        expect(helper.current_user).to eq(nil)
      end
    end
  end

  describe('logged_in?') do
    context('ログインしている時') do
      it('trueを返す') do
        helper.log_in(user)
        expect(helper.logged_in?).to eq(true)
      end
    end

    context('ログインしていない時') do
      it('falseを返す') do
        expect(helper.logged_in?).to eq(false)
      end
    end
  end

  describe('new_token') do
    it('tokenを返す') do
      expect(helper.new_token.class).to eq(String)
      expect(helper.new_token.length > 24).to eq(true)
    end
  end

  describe('to_digest(token)') do
    let(:token) { helper.new_token }
    it('tokenをdigest化した文字列を返す') do
      expect(helper.to_digest(token).class).to eq(BCrypt::Password)
    end

    it('tokenとdigestは元は同じ文字列である') do
      user.session_digest = helper.to_digest(token)
      expect(user.authenticate?(token)).to eq(true)
    end
  end

  describe('log_out') do
    it('cookieが削除される') do
      helper.log_in(user)
      helper.log_out
      expect(helper.cookies['user_id'].present?).to eq(false)
    end
  end
end
