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
  validates :title, :annotation, :language, :book_file, :author_ids, :genre_ids, presence: true
  validates :volume, numericality: {greater_than: 0}, allow_nil: true
  validates :language, inclusion: {in: ApplicationRecord::LANGUAGES}
  validates :date_of_publication, presence: true
  validates :date_of_publication, date: true

  validate :has_an_author

  protected

  def parse_book
    @query = Array.new
    if self.book_file?
      parsed_book = EPUB::Parser.parse(self.book_file.path)
      if self.title.blank?
        (parsed_title = parsed_book.metadata.title).blank? ? @query<<"title" : self.title = parsed_title
      end
      if self.language.blank?
        (parsed_language = I18nData.languages[parsed_book.metadata.language.to_s.upcase]).blank? ? @query<<"language" : self.language = parsed_language
      end
      if self.date_of_publication.blank?
        (parsed_date_of_publication = Time.parse(parsed_book.metadata.date.to_s) rescue nil).blank? ? @query<<"date_of_publication" : self.date_of_publication = parsed_date_of_publication
      end
      if self.annotation.blank?
        (parsed_annotation = ActionView::Base.full_sanitizer.sanitize(parsed_book.metadata.description)).blank? ? @query<<"annotation" : self.annotation = parsed_annotation
      end
      if self.cover.blank?
        !(opened_file = cover_image(parsed_book)).blank? && !(parsed_cover = File.open(opened_file, 'r')).blank? ? self.cover = parsed_cover : nil
      end
    end
  ensure
    if !parsed_cover.blank?
      File.delete(parsed_cover) if File.exist?(parsed_cover)
      parsed_cover.close unless parsed_cover.closed?
    end
  end

  def cover_image(book)
    cover_types = %w(cover-image cover coverimage)
    tmp_dir = "tmp/"
    Dir.mkdir(tmp_dir) unless Dir.exist?(tmp_dir)
    if book.package.version.match('^3.*')
      found_cover = extract_file_from_zip(self.book_file.current_path, book.manifest.cover_image.href.to_s)
    elsif book.package.version.match('^2.*')
      book.resources.each do |resource|
        if resource.id.downcase.in?(cover_types)
          found_cover = extract_file_from_zip(self.book_file.current_path, resource.href.to_s)
        end
      end
    end
    if !found_cover.blank?
      tmp_filepath = tmp_dir + File.basename(found_cover.name)
      found_cover.extract(tmp_filepath) if !tmp_filepath.blank?
      return tmp_filepath
    end
  end

  def extract_file_from_zip(zip_path, file_name)
    Zip::File.open(zip_path) do |zip_file|
      return zip_file.glob('**/' + file_name).first
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

  def has_an_author
    errors.add(:book, 'must add at least one author') if self.authors.empty? || self.authors.all? {|author| author.marked_for_destruction?}
  end
end
