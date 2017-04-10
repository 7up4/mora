class BookPublisher < ApplicationRecord
  belongs_to :book
  belongs_to :publisher
  validates_presence_of :book
  validates_presence_of :publisher
end
