class CreateCollaborations < ActiveRecord::Migration[8.0]
  def change
    create_table :collaborations do |t|
      t.references :book, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :collaborations, %i[book_id user_id], unique: true
  end
end
