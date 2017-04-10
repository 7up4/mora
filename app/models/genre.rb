class Genre < ApplicationRecord
  has_many :book_genres

  has_many :books, through: :book_genres

  validates :genre_name, presence: true, uniqueness: true
end
