class CreateBookPublishers < ActiveRecord::Migration[5.0]
  def change
    create_table :book_publishers do |t|
      t.references :book, foreign_key: true
      t.references :publisher, foreign_key: true

      t.timestamps
    end
  end
end
