class Product < ApplicationRecord
  include(Messageable)
  belongs_to(:user)
  belongs_to(:shipping_day)
  belongs_to(:status)
  belongs_to(:category)
  has_many(:likes, dependent: :destroy)
  has_many(:like_users, through: :likes, source: :user)
  has_one(:purchaced_product)
  has_many_attached(:images, dependent: :destroy)

  attr_accessor(:image)

  default_scope(-> { with_attached_images.order(id: :asc) })
  scope(:search, ->(search_params) {
    return all if search_params.select { |k, v| !v.nil? && !v.empty? }.empty?
    search_by_keywords(search_params[:keywords])
      .search_by_category(search_params[:category_id])
      .search_by_shipping_days(search_params[:status_ids])
      .search_by_shipping_days(search_params[:shipping_day_ids])
      .where(traded: false)
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

  validates(:name, presence: true, length: { maximum: 50 })
  validates(:description, presence: true, length: { maximum: 300 })
  validates(:images, file_present_images: true, content_type_images: true, file_size_images: true)

  after_update_commit(:destroy_likes)

  def self.as_json(products)
    products.map { |p| p.as_json }
  end

  def as_json
    base64_image = images[0].blob.open do |file|
      'data:image/png;base64,' + Base64.encode64(file.read)
    end
    { id: id, name: name, image: base64_image, url: "/products/#{id}" }
  end

  def set_image_as_base64(index)
    images.blobs[index].open do |file|
      self.image = 'data:image/png;base64,' + Base64.encode64(file.read)
    end
  end

  private
    def destroy_likes
      likes.destroy_all if saved_change_to_traded?
    end
end