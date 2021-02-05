class EvaluationsController < ApplicationController
  before_action(:log_in_user)
  before_action(:set_product)
  before_action(:product_not_have_evaluation)
  before_action(:product_already_received)
  before_action(:correct_user)

  def new # GET /products/:product_id/evaluations/new
    @evaluation = @product.build_evaluation
  end

  def create # POST /products/:product_id/evaluations
    @evaluation = @product.build_evaluation(score: params[:evaluation][:score])
    if @evaluation.save
      flash[:success] = '評価しました。'
      redirect_to(root_url)
    else
      render('new')
    end
  end

  private
    def set_product
      @product = Product.find(params[:product_id])
    end

    def product_not_have_evaluation
      if @product.evaluation
        flash[:danger] = 'すでに評価済みです。'
        redirect_to(root_url)
      end
    end

    def product_already_received
      unless @product.todo.received?
        flash[:danger] = 'まだ、取引中です。'
        redirect_to(root_url)
      end
    end

    def correct_user
      if current_user != @product.purchace_user
        flash[:danger] = '有効なユーザーではありません。'
        redirect_to(root_url)
      end
    end
end
