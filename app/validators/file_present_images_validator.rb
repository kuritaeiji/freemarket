class FilePresentImagesValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.empty?
      record.errors.add(attribute, 'を添付して下さい')
    end
  end
end