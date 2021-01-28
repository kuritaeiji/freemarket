class ContentTypeImagesValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    valid_types = ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']
    if !value.empty? && !value.all? { |image| valid_types.include?(image.content_type) }
      record.errors.add(attribute, 'には画像を添付して下さい')
    end
  end
end