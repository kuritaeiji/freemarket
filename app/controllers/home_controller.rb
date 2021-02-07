class HomeController < ApplicationController
  def home
    @products = Product.all.where(traded: false).order(created_at: :desc).take(20)
  end
end
