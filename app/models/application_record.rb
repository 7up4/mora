class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  LANGUAGES = Country.all.map{|x| x.alpha2}
  GENDERS = ['m', 'f']

  protected

  def set_reader
    self.reader=Reader.current
  end
end
