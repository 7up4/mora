class CreateBookReaders < ActiveRecord::Migration[5.0]
  def change
    create_table :book_readers do |t|
      t.references :book, foreign_key: true
      t.references :reader, foreign_key: true

      t.timestamps
    end
  end
end
