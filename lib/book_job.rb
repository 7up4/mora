class BookJob < Struct.new(:book_id)
  def perform
    book = Book.find(book_id)
    parsed_book = EPUB::Parser.parse(book.book_file.path)
    parsed_volume = 0
    parsed_book.resources.select(&:xhtml?).each do |xhtml|
      doc = xhtml.content_document.nokogiri
      body = doc.search('body').first
      content = body.content
      parsed_volume += content.scan(/\S+/).length if body
    end
    book.update_attribute(:volume, parsed_volume)
  end
end
