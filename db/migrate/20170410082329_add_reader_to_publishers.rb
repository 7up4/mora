class AddReaderToPublishers < ActiveRecord::Migration[5.0]
  def change
    add_reference :publishers, :reader, foreign_key: true
  end
end
