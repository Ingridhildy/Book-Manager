class CreateAuthors < ActiveRecord::Migration[8.0]
  def change
    create_table :authors do |t|
      t.string :name, null: false
      t.string :country
      t.integer :birth_year
      t.references :book, null: false, foreign_key: true

      t.timestamps
    end
  end
end
