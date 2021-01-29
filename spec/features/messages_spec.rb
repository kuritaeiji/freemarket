require 'rails_helper'

RSpec.feature "Messages", type: :feature do
  scenario('メッセージのバリデーション', js: true) do
    product = create(:product)
    visit(product_path(product.id))
    fill_in('message_content', with: 'a' * 300)
    expect(page).to have_selector('p', text: '200文字以内で入力して下さい。')
  end

  scenario('メッセージを作成する') do
    user = create(:user)
    product = create(:product)

    log_in_feature(user)
    expect {
      visit(product_path(product.id))
      fill_in('message_content', with: 'テストメッセージ')
      click_on('メッセージを送る')
    }.to change(Message, :count).by(1)
    expect(page).to have_selector('.message-content', text: 'テストメッセージ')
  end

  scenario('メッセージを削除する') do
    user = create(:user)
    product = create(:product)
    message = create(:message, messageable: product, user: user)

    log_in_feature(user)
    expect {
      visit(product_path(product.id))
      find('.message-delete-link').click
    }.to change(Message, :count).by(-1)
  end
end
