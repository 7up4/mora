class Reader < ApplicationRecord
  before_destroy :remove_associations
  after_destroy :remove_ownerless_books

  # Set current_reader visible to work with author model after building nested forms
  def self.current
    Thread.current[:reader]
  end
  def self.current=(reader)
    Thread.current[:reader] = reader
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :book_readers
  has_many :books, through: :book_readers, dependent: :destroy
  has_many :authors
  has_many :publishers

  mount_uploader :avatar, AvatarUploader

  validates :first_name, :last_name, :nick, presence: true
  validates :nick, uniqueness: true, length: {maximum: 25}
  validates :gender, inclusion: {in: GENDERS}

  protected

  def remove_associations
    self.authors.delete(authors)
    self.publishers.delete(publishers)
  end

  def remove_ownerless_books
    Book.all.each do |book|
      unless book.readers.exists?
        book.destroy.delete
      end
    end
  end
end
