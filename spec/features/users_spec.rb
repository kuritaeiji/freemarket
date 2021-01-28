require 'rails_helper'
include(ActiveJob::TestHelper)

RSpec.feature "Users", type: :feature do
  let(:user) { build(:user) }
  let!(:prefecture) { create(:prefecture) }
  scenario('ユーザーを作成できる') do
    visit(new_user_path)

    expect {
      fill_in('メールアドレス', with: user.email)
      fill_in('パスワード（大文字、小文字、数字を含み8文字以上）', with: user.password)
      fill_in('パスワード（確認用）', with: user.password_confirmation)
      fill_in('アカウント名', with: user.account_name)
      attach_file('アイコン画像', "#{Rails.root}/spec/images/a.jpg")
      fill_in('名字', with: user.family_name)
      fill_in('名前', with: user.first_name)
      fill_in('郵便番号（ハイフン無し）', with: user.postal_code)
      select(prefecture.name, from: '都道府県')
      fill_in('住所', with: user.address)
      within('.user-form') do
        click_on('登録')
      end
    }.to change(User, :count).by(1) && change(ActiveStorage::Attachment, :count).by(1)

    expect(current_path).to eq(root_path)
    expect(page).to have_selector('.alert.alert-success', text: 'メールを確認してアカウントを有効化してください。')

    mail = ActionMailer::Base.deliveries.last
    aggregate_failures do
      expect(mail.to).to eq([user.email])
      expect(mail.subject).to eq('アカウント有効化')
    end
  end

  scenario('無効なパラメーターを入力するとエラーメッセージが表示される') do
    visit(new_user_path)

    expect {
      fill_in('メールアドレス', with: user.email)
      fill_in('住所', with: user.address)
      within('.user-form') do
        click_on('登録')
      end
    }.not_to change(User, :count)

    expect(page).to have_selector('.alert.alert-danger', text: 'のエラーがあります')
  end

  scenario('住所検索できる', js: true) do
    visit(new_user_path)
    Prefecture.create(id: 13, name: '東京都')

    fill_in('郵便番号（ハイフン無し）', with: '1610035')
    within('.postal-code-search') do
      click_on('検索')
    end

    expect(page).to have_field('住所', with: '新宿区中井')
  end
end
