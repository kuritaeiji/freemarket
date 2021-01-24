class ProductsController < ApplicationController
  def search
    @keywords = search_params[:keywords]
    @products = Product.search(search_params).order_by_option(search_params[:order_option])
      .paginate(page: params[:page], per_page: 100)
  end

  private
    def search_params
      status_ids = params[:product][:status_ids].split(',')
      shipping_day_ids = params[:product][:shipping_day_ids].split(',')
      params.require(:product).permit(:keywords, :category_id, :order_option).merge(status_ids: status_ids, shipping_day_ids: shipping_day_ids)
    end
end
