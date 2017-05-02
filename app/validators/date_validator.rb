class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attr_name, value)
    if value && (value > DateTime.now.to_date)
      record.errors.add(attr_name, :date_of_publication, options.merge(value: value))
    end
  end
end
