require 'rails_helper'

RSpec.describe Message, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:messageable) }
  it { is_expected.to have_many(:notices) }

  it { is_expected.to validate_presence_of(:content) }
  it { is_expected.to validate_length_of(:content).is_at_most(200) }


  it('scope not_sell_user_messages') do
    sell_user = create(:user)
    user = create(:user)
    sell_user_messages = create_list(:message, 3, user: sell_user)
    user_messages = create_list(:message, 3, user: user)
    expect(Message.not_sell_user_messages(sell_user)).to eq(user_messages)
  end

  describe('メッセージを作成するとお知らせを送る') do
    context('商品メッセージの時') do
      let(:user) { create(:user) }
      let(:sell_user) { create(:user) }
      let(:product) { create(:product, user: sell_user) }
      context('商品の出品者がメッセージを送る場合') do
        it('メッセージを送信したユーザーたちにお知らせを送る') do
          user_message = create(:message, user: user, messageable: product)
          sell_user_message = create(:message, user: sell_user, messageable: product)

          notice = Notice.last
          aggregate_failures do
            expect(notice.send_user).to eq(sell_user)
            expect(notice.receive_user).to eq(user)
            expect(notice.noticeable).to eq(sell_user_message)
          end
        end
      end

      context('商品の出品者でないユーザーがメッセージを送る場合') do
        it('商品の出品者にお知らせを送る') do
          message = create(:message, user: user, messageable: product)

          notice = Notice.first
          aggregate_failures do
            expect(notice.send_user).to eq(user)
            expect(notice.receive_user).to eq(sell_user)
            expect(notice.noticeable).to eq(message)
          end
        end
      end
    end
  end
end
