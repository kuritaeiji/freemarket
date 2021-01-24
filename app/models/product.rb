class Product < ApplicationRecord
  belongs_to(:user)
  belongs_to(:shipping_day)
  belongs_to(:status)
  belongs_to(:category)

  default_scope(-> { order(created_at: :desc) })
  scope(:search, ->(search_params) {
    return all if search_params.select { |k, v| !v.nil? && !v.empty? }.empty?
    search_by_keywords(search_params[:keywords])
      .search_by_category(search_params[:category_id])
      .search_by_shipping_days(search_params[:status_ids])
      .search_by_shipping_days(search_params[:shipping_day_ids])
      .where(trading: false)
  })
  scope(:order_by_option, ->(option) {
    if option == '1'
      order(price: :asc)
    elsif option == '2'
      order(price: :desc)
    else
      order(created_at: :desc)
    end
  })

  scope(:search_by_keywords, ->(keywords) {
    if keywords
      against_key = keywords.split(/[[:blank:]]+/).map { |keyword| "+#{keyword}"}.join(' ')
      where('match(name, description) against (? in boolean mode)', against_key)
    end
  })
  scope(:search_by_category, ->(category_id) { where(category_id: category_id) unless category_id.empty? })
  scope(:search_by_statuses, ->(status_ids) { where(status: status_ids) unless status_ids.empty? })
  scope(:search_by_shipping_days, ->(day_ids) { where(shipping_day_id: day_ids) unless day_ids.empty? })
end