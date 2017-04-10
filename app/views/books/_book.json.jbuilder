json.extract! book, :id, :title, :date_of_publication, :annotation, :volume, :language, :cover, :book_file, :created_at, :updated_at
json.url book_url(book, format: :json)
