class ProductsController < ApplicationController
  before_action(:log_in_user, only: [:new, :create, :edit, :update, :index])
  before_action(:set_product, only: [:show, :edit, :update, :destroy])
  before_action(:correct_user, only: [:edit, :update, :destroy])
  before_action(:untraded_product, only: [:edit, :update, :destroy])

  def index
  end

  def show
    @product.set_image_as_base64(0)
  end

  def new
    @product = Product.new
  end

  def create
    @product = current_user.products.new(product_params)
    if @product.save
      flash[:success] = '出品しました。'
      redirect_to(@product)
    else
      render('new')
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      flash[:success] = '商品を更新しました。'
      redirect_to(@product)
    else
      render('edit')
    end
  end

  def destroy
    @product.destroy
    flash[:success] = '商品を削除しました。'
    redirect_to(root_url)
  end

  def search
    @keywords = search_params[:keywords]
    @products = Product.search(search_params).order(created_at: :desc).paginate(page: params[:page], per_page: 52)
  end

  private
    def set_product
      @product = Product.find(params[:id])
    end

    def correct_user
      unless @product.user == current_user
        flash[:danger] = '正しいユーザーではありません。'
        redirect_to(root_url)
      end
    end

    def untraded_product
      if @product.traded? || @product.solded?
        flash[:danger] = 'すでに取引された商品です。'
        redirect_to(root_url)
      end
    end

    def search_params
      status_ids = params[:product][:status_ids].split(',')
      shipping_day_ids = params[:product][:shipping_day_ids].split(',')
      params.require(:product).permit(:keywords, :category_id, :order_option).merge(status_ids: status_ids, shipping_day_ids: shipping_day_ids)
    end

    def product_params
      images = [params[:product][:image1], params[:product][:image2], params[:product][:image3], params[:product][:image4]]
        .select { |image| image && image.class != String}
      params.require(:product).permit(:name, :description, :category_id, :status_id, :shipping_day_id)
        .merge(images: images)
    end
end