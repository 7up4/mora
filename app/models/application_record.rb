class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  LANGUAGES = I18nData.languages.values.map{|code| code.split(';').first}
  GENDERS = ['m', 'f']

  protected

  def set_reader
    self.reader=Reader.current
  end
end
