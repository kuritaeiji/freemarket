class Api::LikesController < ApplicationController
  before_action(:log_in_user)
  before_action(:correct_create_user, only: [:create])
  before_action(:correct_destroy_user, only: [:destroy])

  def create
    current_user.likes.create!(product: @product)
    render(json: { status: 'success' })
  end

  def destroy
    @like.destroy
    render(json: { status: 'success' })
  end

  private
    def correct_create_user
      @product = Product.find(params[:product_id])
      if current_user == @product.user
        flash[:danger] = '出品者はいいねできません。'
        redirect_to(root_url)
      end
    end

    def correct_destroy_user
      @like = Like.find(params[:id])
      unless current_user == @like.user
        flash[:danger] = '正しいユーザーではありません。'
        redirect_to(root_url)
      end
    end
end
