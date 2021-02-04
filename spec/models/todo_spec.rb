require 'rails_helper'

RSpec.describe Todo, type: :model do
  it { is_expected.to belong_to(:product) }
  it { is_expected.to have_many(:messages).dependent(:destroy) }
  it { is_expected.to have_many(:notices).dependent(:destroy) }

  it('shippedがtrueに更新されると発送メッセージを作成する') do
    todo = create(:todo)
    expect {
      todo.update(shipped: true)
    }.to change(Message, :count).by(1)
    message = Message.last
    expect(message.content).to eq('商品を発送しました。')
    expect(message.user).to eq(todo.product.sell_user)
  end

  it('receivedがtrueに更新されると取引終了通知が作成される') do
    todo = create(:todo)
    expect {
      todo.update(received: true)
    }.to change(Notice, :count).by(1)
    notice = Notice.last
    expect(notice.send_user).to eq(todo.product.purchace_user)
    expect(notice.receive_user).to eq(todo.product.sell_user)
  end

  describe('can_send_message?(current_user)') do
    let(:current_user) { create(:user) }
    context('ログインユーザーが出品者の時') do
      let(:product) { create(:purchace_product, user: current_user) }
      context('すでに受け取り済みの時') do
        let(:todo) { build(:todo, received: true, product: product) }
        it('falseを返す') do
          expect(todo.can_send_message?(current_user)).to eq(false)
        end
      end

      context('まだ受け取っていない時') do
        let(:todo) { build(:todo, product: product) }
        it('trueを返す') do
          expect(todo.can_send_message?(current_user)).to eq(true)
        end
      end
    end

    context('ログインユーザーが購入者の時') do
      let(:product) { create(:purchace_product, purchace_user: current_user) }
      context('すでに受け取り済みの時') do
        let(:todo) { build(:todo, received: true, product: product) }
        it('falseを返す') do
          expect(todo.can_send_message?(current_user)).to eq(false)
        end
      end

      context('まだ受け取っていない時') do
        let(:todo) { build(:todo, product: product) }
        it('trueを返す') do
          expect(todo.can_send_message?(current_user)).to eq(true)
        end
      end
    end

    context('ログインユーザーが購入者でも出品者でもない時') do
      let(:todo) { create(:todo) }
      it('falseを返す') do
        expect(todo.can_send_message?(current_user)).to eq(false)
      end
    end
  end

  describe('create_notice(message)') do
    let(:sell_user) { create(:user) }
    let(:purchace_user) { create(:user) }
    let(:product) { create(:product, user: sell_user, purchace_user: purchace_user) }
    let(:todo) { create(:todo, product: product) }
    context('メッセージユーザーが購入者である時') do
      it('購入者から出品者へのお知らせを作成する') do
        expect {
          message = todo.messages.create(user: purchace_user, content: 'test')
        }.to change(Notice, :count).by(1)
        n = Notice.last
        expect(n.send_user).to eq(purchace_user)
        expect(n.receive_user).to eq(sell_user)
      end
    end

    context('メッセージユーザーが出品者である時') do
      it('出品者から購入者へのお知らせを作成する') do
        expect {
          message = todo.messages.create(user: sell_user, content: 'test')
        }.to change(Notice, :count).by(1)
        n = Notice.last
        expect(n.send_user).to eq(sell_user)
        expect(n.receive_user).to eq(purchace_user)
      end
    end
  end

  describe('notice_messgeable_body(message)') do
    it('todoのメッセージに対するお知らせの本文を返す') do
      todo = create(:todo)
      message = create(:todo_message, messageable: todo)
      expect(todo.notice_messageable_body(message)).to eq("#{message.user.account_name}が#{todo.product.name}にメッセージを送りました。")
    end
  end

  describe('notice_messageable_image') do
    it('商品画像の一枚目を返す') do
      todo = create(:todo)
      expect(todo.notice_messageable_image).to eq(todo.product.images[0])
    end
  end

  describe('notice_path') do
    context('受け取っていない時') do
      it('todo詳細ページのパスを返す') do
        todo = create(:todo)
        expect(todo.notice_messageable_path).to eq("/todos/#{todo.id}")
      end
    end

    context('すでに受け取っている時') do
      it('#を返す') do
        todo = create(:todo, received: true)
        expect(todo.notice_messageable_path).to eq('#')
      end
    end
  end

  describe('notice_body') do
    it('お知らせの本文を返す') do
      todo = create(:todo)
      expect(todo.notice_body).to 
        eq("#{todo.product.purchace_user.account_name}が商品#{todo.product.name}を受けとったため取引が終了しました。")
    end
  end

  describe('notice_path') do
    it('#を返す') do
      todo = create(:todo)
      expect(todo.notice_path).to eq('#')
    end
  end

  describe('notice_image') do
    it('商品画像の一枚目を返す') do
      todo = create(:todo)
      expect(todo.notice_image).to eq(todo.product.images[0])
    end
  end
end
