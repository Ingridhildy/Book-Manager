# Модель книги каталогу
class Book < ApplicationRecord
  enum :status, { want_to_read: 0, reading: 1, read: 2 }

  validates :title, presence: true
  validates :status, presence: true
  validates :pages, numericality: { greater_than: 0, allow_nil: true }
  validates :rating, numericality: { in: 0..10, allow_nil: true }

  # --- Scopes ---

  # Два scope по статусу
  scope :read_books,    -> { where(status: :read) }
  scope :planned_books, -> { where(status: :want_to_read) }

  # Scope по числовому полю: книги з рейтингом >= 8
  scope :highly_rated,  -> { where("rating >= ?", 8.0) }

  # Scope по даті: книги опубліковані за останні 5 років
  scope :recent,        -> { where("published_date >= ?", 5.years.ago) }
end
