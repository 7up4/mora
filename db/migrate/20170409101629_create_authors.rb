class CreateAuthors < ActiveRecord::Migration[5.0]
  def change
    create_table :authors do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :second_name
      t.string :gender, null: false, limit: 1
      t.text :biography
      t.string :photo

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        execute("ALTER TABLE authors ADD CONSTRAINT chk_gender CHECK(gender IN ('m', 'f'))")
      end
      dir.down do
        execute("ALTER TABLE authors DROP CONSTRAINT chk_gender")
      end
    end
  end
end
