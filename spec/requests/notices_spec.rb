require 'rails_helper'

RSpec.describe "Notices", type: :request do
  describe('GET /notices') do
    context('ログインしていない時') do
      it('ログイン画面にリダイレクトする') do
        get(notices_path)
        expect(response).to redirect_to(log_in_path)
      end
    end

    context('ログインしている時') do
      let(:user) { create(:user) }
      let!(:notices) { create_list(:notice, 2, receive_user: user) }
      it('未読のお知らせを既読にする') do
        log_in_request(user)
        get(notices_path)

        notices.each { |n| n.reload }
        expect(notices.all? { |n| n.read? }).to eq(true)
      end
    end
  end
end
