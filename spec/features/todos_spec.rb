require 'rails_helper'

RSpec.feature "Todos", type: :feature do
  scenario('商品を購入し評価するまで') do
    sell_user = create(:user)
    purchace_user = create(:user)
    product = create(:product, user: sell_user)

    log_in_feature(purchace_user)

    expect {
      visit(product_path(product))
      click_on('購入する')
    }.to change(Todo, :count).by(1)

    todo = Todo.first

    expect(current_path).to eq(todo_path(todo))
    expect(page).to have_selector('.alert.alert-info', text: '出品者にメッセージを送りましょう。')
    log_out_feature(purchace_user)

    log_in_feature(sell_user)
    visit(todo_path(todo))
    expect(page).to have_selector('.alert.alert-info', text: '発送して下さい。')

    expect {
      click_on('発送を通知する')
    }.to change(Message, :count).by(1)
    expect(current_path).to eq(todo_path(todo))
    expect(todo.reload.shipped?).to eq(true)
    expect(page).to have_selector('.alert.alert-success', text: '発送通知をしました。')
    expect(page).not_to have_selector('a', text: '発送を通知する')
    log_out_feature(sell_user)

    log_in_feature(purchace_user)
    visit(todo_path(todo))
    expect(page).to have_selector('.alert.alert-info', text: '出品者が発送しました。荷物を受け取りましょう。')
    click_on('荷物を受け取りました')

    expect(todo.reload.received?).to eq(true)
    expect(current_path).to eq(new_product_evaluation_path(todo))
    
    expect {
      choose('evaluation_score_1')
      click_on('評価する')
    }.to change(Evaluation, :count).by(1)

    expect(page).to have_selector('.alert.alert-success', text: '評価しました。')
  end
end
