require 'rails_helper'

RSpec.feature "TodoMessages", type: :feature do
  scenario('todoに対してメッセージの作成と削除ができる') do
    sell_user = create(:user)
    purchace_user = create(:user)
    product = create(:purchace_product, user: sell_user, purchace_user: purchace_user)
    todo = create(:todo, product: product)

    log_in_feature(sell_user)
    visit(todo_path(todo))
    expect { 
      fill_in('message_content', with: 'sell_user_test_message')
      click_on('メッセージを送る')
    }.to change(sell_user.messages, :count).by(1)
    sell_user_message = sell_user.messages[0]
    expect(page).to have_selector('.message-content', text: 'sell_user_test_message')
    log_out_feature(sell_user)

    log_in_feature(purchace_user)
    visit(todo_path(todo))
    expect { 
      fill_in('message_content', with: 'purchace_user_test_message')
      click_on('メッセージを送る')
    }.to change(purchace_user.messages, :count).by(1)
    purchace_user_message = purchace_user.messages[0]
    expect(page).to have_selector('.message-content', text: 'purchace_user_test_message')

    find('.message-delete-link').click
    expect(purchace_user.messages.count).to eq(0)
  end
end
