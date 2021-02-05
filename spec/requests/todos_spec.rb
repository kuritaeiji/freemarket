require 'rails_helper'

RSpec.describe "Todos", type: :request do
  describe('GET /todos/:id') do
    let(:user) { create(:user) }
    context('ログインしていない時') do
      it('ログイン画面にリダイレクトする') do
        get(todo_path(1))
        expect(response).to redirect_to(log_in_url)
      end
    end

    context('受け取っている時') do
      let(:product) { create(:purchace_product, user: user) }
      let(:todo) { create(:todo, received: true, product: product)}
      it('ホーム画面にリダイレクトする') do
        log_in_request(user)
        get(todo_path(todo))
        expect(response).to redirect_to(root_url)
      end
    end

    context('出品者でも購入者でもない時') do
      let(:todo) { create(:todo)}
      it('ホーム画面にリダイレクトする') do
        log_in_request(user)
        get(todo_path(todo))
        expect(response).to redirect_to(root_url)
      end
    end

    context('認可された時') do
      let(:product) { create(:purchace_product, user: user) }
      let(:todo) { create(:todo, product: product) }

      it('200レスポンスを返す') do
        log_in_request(user)
        get(todo_path(todo))
        expect(response.status).to eq(200)
      end
    end
  end

  describe('PUT /todos/:id/ship') do
    let(:user) { create(:user) }
    context('すでに発送されている時') do
      let(:product) { create(:purchace_product, user: user) }
      let(:todo) { create(:todo, product: product, shipped: true) }
      it('ホーム画面にリダイレクトする') do
        log_in_request(user)
        put(ship_todo_path(todo))
        expect(response).to redirect_to(root_url)
      end
    end

    context('出品者でない時') do
      let(:product) { create(:purchace_product) }
      let(:todo) { create(:todo, product: product) }
      it('ホーム画面にリダイレクトする') do
        log_in_request(user)
        put(ship_todo_path(todo))
        expect(response).to redirect_to(root_url)
      end
    end

    context('認可されたユーザーである時') do
      let(:product) { create(:purchace_product, user: user) }
      let(:todo) { create(:todo, product: product) }
      it('発送済みに更新する') do
        log_in_request(user)
        put(ship_todo_path(todo))
        expect(todo.reload.shipped?).to eq(true)
      end

      it('todo詳細画面にリダイレクトする') do
        log_in_request(user)
        put(ship_todo_path(todo))
        expect(response).to redirect_to(todo_path(todo))
      end
    end
  end

  describe('PUT /todos/:id/receive') do
    let(:user) { create(:user) }
    context('すでに受け取っている時') do
      let(:product) { create(:purchace_product, purchace_user: user) }
      let(:todo) { create(:todo, received: true, product: product) }
      it('ホーム画面にリダイレクトする') do
        log_in_request(user)
        put(receive_todo_path(todo))
        expect(response).to redirect_to(root_url)
      end
    end

    context('購入者でない時') do
      let(:todo) { create(:todo) }
      it('ホーム画面にリダイレクトする') do
        log_in_request(user)
        put(receive_todo_path(todo))
        expect(response).to redirect_to(root_url)
      end
    end

    context('認可されたユーザであるとき') do
      let(:product) { create(:purchace_product, purchace_user: user) }
      let(:todo) { create(:todo, product: product) }
      it('受け取り済みに更新する') do
        log_in_request(user)
        put(receive_todo_path(todo))
        expect(todo.reload.received?).to eq(true)
      end

      it('評価画面にリダイレクトする') do
        log_in_request(user)
        put(receive_todo_path(todo))
        expect(response).to redirect_to(new_product_evaluation_url(todo.product))
      end
    end
  end
end