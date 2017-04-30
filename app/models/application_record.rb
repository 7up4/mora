class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  LANGUAGES = I18nData.languages.keys.map{|code| code.downcase}
  GENDERS = ['m', 'f']

  protected

  def set_reader
    self.reader=Reader.current
  end
end
