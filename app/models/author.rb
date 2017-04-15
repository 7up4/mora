class Author < ApplicationRecord
  before_save :set_reader

  has_many :author_books, dependent: :destroy
  has_many :books, through: :author_books
  belongs_to :reader, optional: true

  mount_uploader :photo, PhotoUploader

  validates :first_name, :last_name, presence: true
  validates :gender, inclusion: {in: ApplicationRecord::GENDERS}
end
