class PurchacedProductsController < ApplicationController
  before_action(:log_in_user)
  before_action(:set_purchaced_product, only: [:show, :ship, :receive])
  before_action(:already_received_purchaced_product, only: [:show])
  before_action(:show_correct_user, only: [:show])
  before_action(:not_ship_and_correct_user, only: [:ship])
  before_action(:not_receive_and_correct_user, only: [:receive])
  before_action(:untraded_product, only: [:create])

  def index # GET /purchaced_products
  end

  def show # GET /purchaced_products/:id
    @p_p = PurchacedProduct.preload(messages: { user: { image_attachment: :blob } }).find(params[:id])
    @message = Message.new
  end

  def create # POST /products/:product_id/purchaced_products
    p_p = current_user.purchaced_products.create(product: @product)
    redirect_to(p_p)
  end

  def ship # PUT /purchaced_products/:id/ship
    @p_p.update(shipped: true)
    flash[:success] = '発送通知をしました。'
    redirect_to(@p_p)
  end

  def receive # PUT /purchaced_products/:id/:receive
    @p_p.update(received: true)
    redirect_to(new_purchaced_product_evaluation_url(@p_p))
  end

  private
    def set_purchaced_product
      @p_p = PurchacedProduct.find(params[:id])
    end

    def already_received_purchaced_product
      if @p_p.received?
        flash[:danger] = 'すでに取引が終了した商品です。'
        redirect_to(root_url)
      end
    end

    def show_correct_user
      if @p_p.sell_user != current_user && @p_p.purchace_user != current_user
        flash[:danger] = '有効なユーザーではありません'
        redirect_to(root_url)
      end
    end

    def not_ship_and_correct_user
      if @p_p.shipped? || current_user != @p_p.sell_user
        flash[:danger] = 'すでに発送されているか、有効なユーザーではありません。'
        redirect_to(root_url)
      end
    end

    def not_receive_and_correct_user
      if @p_p.received? || current_user != @p_p.purchace_user
        flash[:danger] = 'すでに受け取っているか、有効なユーザーではありません。'
        redirect_to(root_url)
      end
    end

    def untraded_product
      @product = Product.find(params[:product_id])
      if @product.traded? || @product.solded?
        flash[:danger] = 'すでに取引された商品です。'
        redirect_to(root_url)
      end
    end
end
