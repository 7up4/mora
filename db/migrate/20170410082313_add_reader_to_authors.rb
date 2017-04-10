class AddReaderToAuthors < ActiveRecord::Migration[5.0]
  def change
    add_reference :authors, :reader, foreign_key: true
  end
end
