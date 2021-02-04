class Api::PurchaceProductsController < ApplicationController
  before_action(:log_in_user)

  def index
    purchace_products = current_user.purchace_products
    products = purchace_products.select { |p| !p.received? }
    products_as_json = Product.as_json(products)
    render(json: products_as_json)
  end

  def received_index
    purchace_products = current_user.purchace_products
    products = purchace_products.select { |p| p.received? }
    products_as_json = Product.as_json(products)
    render(json: products_as_json)
  end
end
