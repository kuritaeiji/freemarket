module ProductsHelper
  def get_image_index(images, image)
    images.blobs.find_index(image.blob)
  end
end
