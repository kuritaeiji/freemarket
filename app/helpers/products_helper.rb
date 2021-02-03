module ProductsHelper
  def get_image_index(images, image)
    images.blobs.find_index(image.blob)
  end

  def trade_status(product)
    content_tag(:span, '販売済み', class: 'badge badge-danger') if product.traded?
  end
end
