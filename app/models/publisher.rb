class Publisher < ApplicationRecord
  before_save :set_reader

  has_many :book_publishers, dependent: :destroy
  has_many :books, through: :book_publishers
  belongs_to :reader, optional: true

  mount_uploader :publisher_logo, PublisherLogoUploader

  validates :publisher_name, presence: true, uniqueness: true
end
