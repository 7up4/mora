class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attr_name, value)
    if value > Time.now
      record.errors[value].add(attr_name, :date_of_publication, options.merge(value: value))
    end
  end
end
