require 'rails_helper'

RSpec.feature "LogIns", type: :feature do
  scenario('アカウントが有効化されていない時ログインできない') do
    user = create(:user, activated: false)
    visit(log_in_path)
    fill_in('メールアドレス', with: user.email)
    fill_in('パスワード', with: user.password)
    within('form') do
      click_on('ログイン')
    end
    expect(current_path).to eq(root_path)
    expect(page).to have_selector('.alert.alert-danger', text: 'メールを確認し、アカウントを有効化して下さい。')
  end

  scenario('ログインできる') do
    user = create(:user)
    visit(log_in_path)
    fill_in('メールアドレス', with: user.email)
    fill_in('パスワード', with: user.password)
    within('form') do
      click_on('ログイン')
    end
    expect(page).to have_selector('.alert.alert-success', text: 'ログインしました。')
    expect(page).to have_selector('a', text: 'ログアウト')
  end
end
