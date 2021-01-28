require 'rails_helper'

RSpec.feature "Products", type: :feature do
  scenario('商品を作成する', js: true) do
    user = create(:user)
    category = create(:category)
    status = create(:status)
    shipping_day = create(:shipping_day)
    log_in_feature(user)

    expect {
      visit(new_product_path)
      expect(page).not_to have_selector('img')
      attach_file('product[image1]', "#{Rails.root}/spec/images/a.jpg", make_visible: true)
      expect(page).to have_selector('img')
      fill_in('商品名', with: '商品1')
      fill_in('商品説明', with: '商品内容')
      within('.new-product-form') do
        click_on('出品する')
      end
    }.to change(Product, :count).by(1)

    product = Product.first
    expect(current_path).to eq(product_path(product))
    expect(page).to have_selector('.alert.alert-success', text: '出品しました。')
  end

  scenario('商品を更新する', js: true) do
    user = create(:user)
    product = create(:product, user: user)
    log_in_feature(user)

    visit(edit_product_path(product.id))
    attach_file('product[image1]', "#{Rails.root}/spec/images/a.jpg", make_visible: true)
    within('.form-images') do
      expect(page).to have_selector('img')
    end
    fill_in('商品名', with: '面白い本')
    fill_in('商品説明', with: '商品内容')
    within('.edit-product-form') do
      click_on('更新する')
    end
    
    expect(product.reload.name).to eq('面白い本')
    expect(page).to have_selector('.alert.alert-success', text: '商品を更新しました。')
  end
end
