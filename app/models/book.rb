class Book < ApplicationRecord
  attr_accessor :delayed_job_id, :query

  before_create :set_book_reader
  before_destroy :remove_associations
  after_create :count_words
  before_destroy :delete_jobs
  before_validation :parse_book, on: :create

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

  validates_associated :authors, :publishers
  validates :title, :annotation, :language, presence: true
  validates :volume, numericality: {greater_than: 0}, allow_nil: true
  validates :language, inclusion: {in: ApplicationRecord::LANGUAGES}
  validates :book_file, presence: true
  validates :date_of_publication, presence: true
  validate :date_of_publication_not_in_future
  validate :has_an_author

  protected

  def parse_book
    @query = Array.new
    if self.book_file?
      parsed_book = EPUB::Parser.parse(self.book_file.path)
      (parsed_title = parsed_book.metadata.title).blank? ? @query<<"title" : self.title = parsed_title
      (parsed_annotation = ActionView::Base.full_sanitizer.sanitize(parsed_book.metadata.description)).blank? ? @query<<"annotation" : self.annotation = parsed_annotation
      (opened_file = cover_image(parsed_book)).blank? || (parsed_cover = File.open(opened_file, 'r')).blank? ? @query<<"cover" : self.cover = parsed_cover
    end
  ensure
    File.delete(parsed_cover) if File.exists?(parsed_cover)
    parsed_cover.close unless parsed_cover.closed?
  end

  def cover_image(book)
    cover_types = %w(cover-image cover)
    tmp_dir = "tmp/"
    Dir.mkdir(tmp_dir) unless Dir.exist?(tmp_dir)
    book.resources.each do |resource|
      if resource.id.in?(cover_types)
        Zip::File.open(self.book_file.current_path) do |zip_file|
          found_cover = zip_file.glob(resource.href.to_s).first
          if !found_cover.blank?
            tmp_filepath = tmp_dir + File.basename(found_cover.name)
            found_cover.extract(tmp_filepath) if !tmp_filepath.blank?
            return tmp_filepath
          end
        end
      end
    end
  end

  def count_words
    @delayed_job_id = Delayed::Job.enqueue(BookJob.new(self))
  end

  def delete_jobs
    Delayed::Job.find(@delayed_job_id).destroy if @delayed_job_id
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
