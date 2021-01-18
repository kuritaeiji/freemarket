class ContentTypeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    content_type = value.content_type
    unless ['image/jpg', 'image/jpeg', 'image/gif', 'image/png'].include?(content_type)
      record.errors.add(attribute, 'を添付して下さい')
    end
  end
end