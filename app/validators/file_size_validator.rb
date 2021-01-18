class FileSizeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.byte_size > 2000000
      record.errors.add(attribute, 'は2MB以内')
    end
  end
end