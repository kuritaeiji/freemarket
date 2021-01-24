require 'rails_helper'

RSpec.feature "ProductSearches", type: :feature do
  scenario('商品を検索する', js: true) do
    user = create(:user)
    category = create(:category)
    category2 = create(:category, name: '2')
    status = create(:status)
    status2 = create(:status, name: '2')
    shipping_day = create(:shipping_day)
    shipping_day2 = create(:shipping_day, days: '2')
    create_list(:product, 5, user: user, category: category, status: status, shipping_day: shipping_day)
    create_list(:product, 5, user: user, category: category2, status: status2, shipping_day: shipping_day2)

    visit(root_path)
    fill_in('product_keywords', with: '商品')
    find('.show-detail-button').click
    select('メンズ', from: 'category_id')
    check('新品、未使用')
    check('1日で発送')
    select('価格の安い順', from: 'order_option')
    within('.input-group-append') do
      click_on('検索')
    end

    expect(page).to have_selector('商品1')
    expect(page).to have_selector('商品2')
    expect(page).to have_selector('商品3')
    expect(page).to have_selector('商品4')
    expect(page).to have_selector('商品5')
  end
end
