class CreateBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.date :date_of_publication
      t.text :annotation, null: false
      t.integer :volume
      t.string :language, null: false
      t.string :cover
      t.string :book_file, null: false

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        execute("ALTER TABLE books ADD CONSTRAINT chk_volume CHECK(volume>0)")
        #execute("ALTER TABLE books ADD CONSTRAINT chk_date_of_publication CHECK(date_of_publication<=(to_char(now(),'YYYY')))")
      end
    end
  end
end
