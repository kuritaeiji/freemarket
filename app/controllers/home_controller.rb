class HomeController < ApplicationController
  def home
    @products = Product.all.order(created_at: :desc).take(20)
  end
end
