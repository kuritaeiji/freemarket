class Api::ProductsController < ApplicationController
  before_action(:log_in_user, only: [:index, :traded_index])

  def index
    products = current_user.products.where(traded: false)
    products_as_json = Product.as_json(products)
    render(json: products_as_json)
  end

  def traded_index
    products = current_user.products.where(traded: true)
    products_as_json = Product.as_json(products)
    render(json: products_as_json)
  end

  def image
    product = Product.find(params[:id])
    product.set_image_as_base64(params[:index].to_i)
    render(json: { image: product.image })
  end
end
