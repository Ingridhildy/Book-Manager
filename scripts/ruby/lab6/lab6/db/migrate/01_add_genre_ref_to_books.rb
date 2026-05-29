class AddGenreRefToBooks < ActiveRecord::Migration[8.0]
  def change
    remove_column :books, :genre, :string
    add_reference :books, :genre, null: true, foreign_key: true
  end
end
