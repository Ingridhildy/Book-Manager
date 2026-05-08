# Модель книги каталогу
class Book < ApplicationRecord
  # Поле status зберігається як Integer, але використовується як рядок
  # want_to_read: 0, reading: 1, read: 2
  enum :status, { want_to_read: 0, reading: 1, read: 2 }

  validates :title, presence: true
  validates :status, presence: true
  validates :pages, numericality: { greater_than: 0, allow_nil: true }
  validates :rating, numericality: { in: 0..10, allow_nil: true }
end
