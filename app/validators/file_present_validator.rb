class FilePresentValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    binding.pry
    unless value
      record.errors.add(attribute, 'を添付して下さい')
    end
  end
end