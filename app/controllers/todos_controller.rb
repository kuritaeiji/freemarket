class TodosController < ApplicationController
  before_action(:log_in_user)
  before_action(:set_todo, only: [:show, :ship, :receive])
  before_action(:not_shipped_todo, only: [:ship])
  before_action(:not_received_todo, only: [:show, :receive])
  before_action(:sell_user, only: [:ship])
  before_action(:purchace_user, only: [:receive])
  before_action(:purchace_user_or_sell_user, only: [:show])

  def index
    @todos = current_user.not_received_todos.paginate(page: params[:page], per_page: 20)
  end

  def show
    @message = Message.new
  end

  def ship
    @todo.update(shipped: true)
    flash[:success] = '発送通知をしました。'
    redirect_to(@todo)
  end

  def receive
    @todo.update(received: true)
    flash[:success] = '出品者を評価して下さい。'
    redirect_to(new_product_evaluation_url(@todo.product))
  end

  private
    def set_todo
      @todo = Todo.preload(product: { images_attachments: :blob }).preload(messages: { user: { image_attachment: :blob } }).find(params[:id])
    end

    def not_shipped_todo
      if @todo.shipped?
        flash[:danger] = 'すでに発送された商品です。'
        redirect_to(root_url)
      end
    end

    def not_received_todo
      if @todo.received?
        flash[:danger] = 'すでに取引が完了しています。'
        redirect_to(root_url)
      end
    end

    def purchace_user
      if current_user != @todo.product.purchace_user
        flash[:danger] = '正しいユーザーではありません。'
        redirect_to(root_url)
      end
    end

    def sell_user
      if current_user != @todo.product.sell_user
        flash[:danger] = '正しいユーザーではありません。'
        redirect_to(root_url)
      end
    end

    def purchace_user_or_sell_user
      if current_user != @todo.product.sell_user && current_user != @todo.product.purchace_user
        flash[:danger] = '正しいユーザーではありません。'
        redirect_to(root_url)
      end
    end
end