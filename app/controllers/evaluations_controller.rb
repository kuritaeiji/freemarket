class EvaluationsController < ApplicationController
  before_action(:log_in_user)
  before_action(:set_purchaced_product)
  before_action(:purchaced_product_not_have_evaluation)
  before_action(:correct_user)

  def new # GET /purchaced_products/:purchaced_product_id/evaluations/new
    @evaluation = @p_p.build_evaluation
  end

  def create # POST /purchaced_products/:purchaced_product_id/evaluations
    @evaluation = @p_p.build_evaluation(score: params[:evaluation][:score])
    if @evaluation.save
      flash[:success] = '評価しました。'
      redirect_to(root_url)
    else
      render('new')
    end
  end

  private
    def set_purchaced_product
      @p_p = PurchacedProduct.find(params[:purchaced_product_id])
    end

    def purchaced_product_not_have_evaluation
      if @p_p.evaluation
        flash[:danger] = 'すでに評価済みです。'
        redirect_to(root_url)
      end
    end

    def correct_user
      if !@p_p.received || current_user != @p_p.purchace_user
        flash[:danger] = 'まだ受け取っていないか、有効なユーザーではありません。'
        redirect_to(root_url)
      end
    end
end
