require 'rails_helper'

RSpec.describe "Messages", type: :request do
  describe('POST /messages') do
    let(:user) { create(:user) }

    context('ログインしていない時') do
      it('ログイン画面にリダイレクトする') do
        post(messages_path)
        expect(response).to redirect_to(log_in_path)
      end
    end

    context('messageableがtodoの時') do
      context('出品者でも購入者でもない時') do
        let(:todo) { create(:todo) }
        it('ホーム画面にリダイレクトする') do
          log_in_request(user)
          post(messages_path, params: { messageable_type: 'Todo', messageable_id: todo.id })
          expect(response).to redirect_to(root_url)
        end
      end

      context('すでに受け取り済みの時') do
        let(:product) { create(:product, user: user) }
        let(:todo) { create(:todo, received: true, product: product) }
        it('ホーム画面にリダイレクトする') do
          log_in_request(user)
          post(messages_path, params: { messageable_type: 'Todo', messageable_id: todo.id })
          expect(response).to redirect_to(root_url)
        end
      end
    end

    context('messageableがproductの時') do
      context('traded: trueの時') do
        let(:product) { create(:product, traded: true) }
        it('ホーム画面にリダイレクトする') do
          log_in_request(user)
          post(messages_path, params: { messageable_type: 'Product', messageable_id: product.id })
          expect(response).to redirect_to(root_url)
        end
      end
    end

    context('ログインしている時') do
      let(:product) { create(:product) }
      context('有効なパラメーターを送信する時') do
        let(:valid_params) { attributes_for(:message) }
        it('メッセージを作成できる') do
          log_in_request(user)
          expect {
            post(messages_path, params: { messageable_type: 'Product', messageable_id: product.id, message: valid_params })
          }.to change(Message, :count).by(1)
        end

        it('商品詳細画面にリダイレクトする') do
          log_in_request(user)
          post(messages_path, params: { messageable_type: 'Product', messageable_id: product.id, message: valid_params })
          expect(response).to redirect_to(product_path(product.id))
        end
      end

      context('無効なパラメーターを送信する時') do
        let(:invalid_params) { attributes_for(:message, content: nil) }
        it('メッセージを作成できない') do
          log_in_request(user)
          expect {
            post(messages_path, params: { messageable_type: 'Product', messageable_id: product.id, message: invalid_params })
          }.not_to change(Message, :count)
        end
      end
    end
  end

  # describe('DELETE /message/:id') do
  #   let(:user) { create(:user) }
  #   let(:product) { create(:product) }
  #   let(:message) { create(:message, user: user, messageable: product) }
  #   context('ログインしていない時') do
  #     it('ログイン画面にリダイレクトする') do
  #       delete(message_path(message.id))
  #       expect(response).to redirect_to(log_in_path)
  #     end
  #   end

  #   context('正しいユーザーでない時') do
  #     let(:other_user) { create(:user) }
  #     it('ホーム画面にリダイレクトする') do
  #       log_in_request(other_user)
  #       delete(message_path(message.id), params: { messageable_type: 'Product', messageable_id: product.id })
  #       expect(response).to redirect_to(product_path(product.id))
  #     end
  #   end

  #   context('正しいユーザーである時') do
  #     it('メッセージを削除できる') do
  #       log_in_request(user)
  #       delete(message_path(message.id), params: { messageable_type: 'Product', messageable_id: product.id })
  #       expect(Message.count).to eq(0)
  #     end

  #     it('商品詳細画面にリダイレクトする') do
  #       log_in_request(user)
  #       delete(message_path(message.id), params: { messageable_type: 'Product', messageable_id: product.id })
  #       expect(response).to redirect_to(product_path(product.id))
  #     end
  #   end
  # end
end
