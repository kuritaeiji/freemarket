require 'rails_helper'

RSpec.feature "Notices", type: :feature do
  scenario('未読のお知らせがある時、件数が表示される') do
    user = create(:user)
    read_notice = create(:notice, receive_user: user, read: true)
    not_read_notice = create(:notice, receive_user: user)

    log_in_feature(user)
    visit(root_path)
    expect(page).to have_selector('.present-notice', text: 'お知らせ1件')
  end
end
