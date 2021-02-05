class ApplicationController < ActionController::Base
  include(SessionsHelper)

  protect_from_forgery(with: :exception)

  before_action(:set_search_variables, :not_have_products_to_evaluate)

  private
    def log_in_user
      unless logged_in?
        flash[:danger] = 'ログインして下さい。'
        redirect_to(log_in_url)
      end
    end

    def not_have_products_to_evaluate
      if logged_in?
        products = current_user.purchace_products.where(solded: false).select { |p| p.received? }
        unless products.empty?
          flash[:danger] = 'ユーザーを評価して下さい。'
          redirect_to(new_product_evaluation_url(products[0]))
        end
      end
    end

    def set_referer_to_session
      session[:referer] = request.referer
    end

    def redirect_referer_or(url)
      redirect_to(session[:referer] || url)
      session.delete(:referer)
    end

    def set_search_variables
      @keywords = nil
      @order_options = [{ id: 1, name: '価格の安い順' }, { id: 2, name: '価格の高い順' }]
    end
end