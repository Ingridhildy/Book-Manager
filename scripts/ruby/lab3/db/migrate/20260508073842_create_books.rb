class CreateBooks < ActiveRecord::Migration[8.1]
  def change
    create_table :books do |t|
      t.string :title
      t.string :genre
      t.string :publisher
      t.date :published_date
      t.integer :pages
      t.float :rating
      t.integer :status

      t.timestamps
    end
  end
end
