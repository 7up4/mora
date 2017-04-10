class CreateGenres < ActiveRecord::Migration[5.0]
  def change
    create_table :genres do |t|
      t.string :genre_name, null: false

      t.index :genre_name, unique: true
      t.timestamps
    end
  end
end
