require 'rails_helper'

RSpec.feature "Likes", type: :feature do
  let(:user) { create(:user) }
  let(:product) { create(:product) }
  let!(:likes) { create_list(:like, 3, product: product) }

  scenario('いいね機能', js: true) do
    log_in_feature(user)
    visit(product_path(product.id))
    expect(page).to have_selector('.badge-secondary')
    expect(page).to have_selector('#likes-count', text: '3')

    expect {
      find('#like-badge').click
    }.to change(Like, :count).by(1)
    expect(page).to have_selector('.badge-danger')
    expect(page).to have_selector('#likes-count', text: '4')

    expect {
      find('#like-badge').click
    }.to change(user.likes, :count).by(-1)
    expect(page).to have_selector('.badge-secondary')
    expect(page).to have_selector('#likes-count', text: '3')
  end
end