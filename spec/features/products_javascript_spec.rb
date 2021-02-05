require 'rails_helper'

RSpec.feature "ProductsJavascripts", type: :feature do
  scenario('出品中の商品画面で非同期に取引された商品の一覧とまだ取引されていない商品一覧を切り替えられる', js: true) do
    user = create(:user)
    untraded_products = create_list(:product, 2, user: user)
    traded_products = create_list(:product, 2, traded: true, user: user)
    solded_products = create_list(:product, 2, traded: true, solded: true, user: user)
    log_in_feature(user)

    visit(products_path)
    expect(page).to have_content(untraded_products[0].name)
    expect(page).to have_content(untraded_products[1].name)

    find('h4', text: '取引中').click
    expect(page).to have_content(traded_products[0].name)
    expect(page).to have_content(traded_products[0].name)

    expect(page).not_to have_content(untraded_products[0].name)
    expect(page).not_to have_content(untraded_products[1].name)

    find('h4', text: '取引済み').click
    expect(page).to have_content(solded_products[0].name)
    expect(page).to have_content(solded_products[0].name)

    expect(page).not_to have_content(traded_products[0].name)
    expect(page).not_to have_content(traded_products[1].name)
  end

  scenario('商品詳細画面の写真を切り替えられる', js: true) do
    user = create(:user)
    product = create(:product, :with_multiple_images, user: user)
    log_in_feature(user)

    visit(product_path(product))
    first_img_src = find('#product-image')['src']
    expect(first_img_src).to match('data:image/png;base64')

    find('img[data-index="1"]').click

    second_img_src = find('#product-image')['src']
    expect(second_img_src).to match('data:image/png;base64')
    expect(first_img_src).not_to eq(second_img_src)
  end
end
