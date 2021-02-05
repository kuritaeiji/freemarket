require 'rails_helper'

RSpec.describe TodosHelper, type: :helper do
  describe('todo_count') do
    it('product traded: true, solded: falseなtodoの数を返す') do
      user = create(:user)
      sell_product = create(:purchace_product, user: user)
      create(:purchace_product, user: user, solded: true)
      create(:purchace_product, purchace_user: user, solded: true)
      purchace_product = create(:purchace_product, purchace_user: user)
      Product.all.each do |p|
        p.create_todo
      end

      log_in_helper(user)
      expect(helper.todo_count).to eq(2)
    end
  end

  describe('todo_class') do
    let(:user) { create(:user) }
    context('todo_count > 0の時') do
      let(:product) { create(:purchace_product, user: user) }
      let!(:todo) { create(:todo, product: product)}
      it('present-todo文字列を返す') do
        log_in_helper(user)
        expect(helper.todo_class).to eq('present-todo')
      end
    end

    context('todo_count = 0の時') do
      it('nilを返す') do
        log_in_helper(user)
        expect(helper.todo_class).to eq(nil)
      end
    end
  end

  describe('todo_button') do
    let(:user) { create(:user) }
    context('ログインユーザーが出品者かつ未発送の時') do
      let(:product) { create(:purchace_product, user: user) }
      let(:todo) { create(:todo, product: product) }
      before do
        assign(:todo, todo)
      end
      it('発送通知ボタンを返す') do
        log_in_helper(user)
        expect(helper.todo_button).to include('発送を通知する')
        expect(helper.todo_button).to include("/todos/#{todo.id}/ship")
      end
    end

    context('ログインユーザーが購入者かつ発送済みかつ未受け取りの時') do
      let(:product) { create(:purchace_product, purchace_user: user) }
      let(:todo) { create(:todo, shipped: true, product: product) }
      before do
        assign(:todo, todo)
      end
      it('受け取りボタンを返す') do
        log_in_helper(user)
        expect(helper.todo_button).to include('荷物を受け取りました')
        expect(helper.todo_button).to include("/todos/#{todo.id}/receive")
      end
    end
  end

  describe('todo_alert') do
    let(:user) { create(:user) }
    context('ログインユーザーが購入者である時') do
      let(:product) { create(:purchace_product, purchace_user: user)}
      context('未発送の時') do
        let(:todo) { create(:todo, product: product) }
        before do
          assign(:todo, todo)
        end
        it('出品者にメッセージを送りましょう。') do
          log_in_helper(user)
          expect(helper.todo_alert).to include('出品者にメッセージを送りましょう。')
        end
      end

      context('発送中の時') do
        let(:todo) { create(:todo, product: product, shipped: true) }
        before do
          assign(:todo, todo)
        end
        it('出品者が発送しました。荷物を受け取りましょう。') do
          log_in_helper(user)
          expect(helper.todo_alert).to include('出品者が発送しました。荷物を受け取りましょう。')
        end
      end
    end

    context('ログインユーザーが出品者である時') do
      let(:product) { create(:purchace_product, user: user) }
      context('未発送の時') do
        let(:todo) { create(:todo, product: product) }
        before do
          assign(:todo, todo)
        end
        it('発送して下さい。') do
          log_in_helper(user)
          expect(helper.todo_alert).to include('発送して下さい。')
        end
      end
    end
  end
end
