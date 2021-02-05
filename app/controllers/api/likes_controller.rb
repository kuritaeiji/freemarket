class Api::LikesController < ApplicationController
  before_action(:log_in_user)
  before_action(:correct_create_user_and_untrade_product, only: [:create])
  before_action(:correct_destroy_user, only: [:destroy])

  def create # POST /products/:product_id/likes
    current_user.likes.create!(product: @product)
    render(json: { status: 200 })
  end

  def destroy # DELETE /products/:product_id/like
    @like.destroy
    render(json: { status: 200 })
  end

  private
    def correct_create_user_and_untrade_product
      @product = Product.find(params[:product_id])
      if current_user == @product.user
        flash[:danger] = '出品者はいいねできません。'
        redirect_to(root_url)
      elsif @product.traded?
        flash[:danger] = '取引済みの商品にはいいねできません。'
        redirect_to(root_url)
      end
    end

    def correct_destroy_user
      @like = current_user.likes.find_by(product_id: params[:product_id])
      if !@like || current_user != @like.user
        flash[:danger] = '正しいユーザーではありません。'
        redirect_to(root_url)
      end
    end
end
