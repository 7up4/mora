class CreatePublishers < ActiveRecord::Migration[5.0]
  def change
    create_table :publishers do |t|
      t.string :publisher_name, null: false
      t.string :publisher_location
      t.string :publisher_logo
      
      t.index :publisher_name, unique: true
      t.timestamps
    end
  end
end
