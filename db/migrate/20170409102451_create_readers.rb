class CreateReaders < ActiveRecord::Migration[5.0]
  def change
    create_table :readers do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :second_name
      t.string :gender, null: false, limit: 1
      t.string :nick, null: false, limit: 25
      t.date :birthdate
      t.string :avatar
      t.boolean :admin, default: false
      t.index :nick, unique: true

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        execute("ALTER TABLE readers ADD CONSTRAINT chk_gender CHECK(gender IN ('m','f'))")
      end
      dir.down do
        execute("ALTER TABLE readers DROP CONSTRAINT chk_gender")
      end
    end
  end
end
