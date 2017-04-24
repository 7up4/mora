class Book < ApplicationRecord
  before_create :set_book_reader
  before_destroy :remove_associations
  after_create :count_words

  has_many :book_readers
  has_many :author_books
  has_many :book_genres
  has_many :book_publishers

  has_many :readers, through: :book_readers
  has_many :authors, through: :author_books
  has_many :genres, through: :book_genres
  has_many :publishers, through: :book_publishers

  accepts_nested_attributes_for :authors, allow_destroy: true, reject_if: :invalid_author
  accepts_nested_attributes_for :publishers, allow_destroy: true, reject_if: :invalid_publisher

  mount_uploader :cover, CoverUploader
  mount_uploader :book_file, BookFileUploader

  validates :title, :annotation, :language, presence: true
  validates :volume, numericality: {greater_than: 0}, allow_nil: true
  validates :language, inclusion: {in: ApplicationRecord::LANGUAGES}
  validates :book_file, presence: true
  validate :date_of_publication_not_in_future
  validate :has_an_author

  protected

  def count_words
    Delayed::Job.enqueue(BookJob.new(self))
  end

  def invalid_author(attributes)
    attributes['first_name'].blank? and attributes['last_name'].blank?
  end

  def invalid_publisher(attributes)
    attributes['publisher_name'].blank?
  end

  def set_book_reader
    self.readers<<Reader.current
  end

  def remove_associations
    self.authors.delete(self.authors)
    self.readers.delete(self.readers)
    self.publishers.delete(self.publishers)
    self.genres.delete(self.genres)
  end

  def date_of_publication_not_in_future
    if date_of_publication.present? && date_of_publication > Time.now
      errors.add(:date_of_publication, "can't be in the future")
    end
  end

  def has_an_author
    errors.add(:book, 'must add at least one author') if self.authors.empty? || self.authors.all? {|author| author.marked_for_destruction?}
  end
end
