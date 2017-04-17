class BookPublisher < ApplicationRecord
  belongs_to :book, optional: true
  belongs_to :publisher
  validates_presence_of :publisher
end
