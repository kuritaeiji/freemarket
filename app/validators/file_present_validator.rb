class FilePresentValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.present?
      record.errors.add(attribute, 'を添付して下さい')
    end
  end
end