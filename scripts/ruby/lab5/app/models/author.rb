class Author < ApplicationRecord
  validates :name, presence: true
  validates :book_id, presence: true
  # Зв'язок belongs_to буде у Лабораторній №6
end
