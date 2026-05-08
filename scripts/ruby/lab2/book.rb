require 'date'

# Клас-модель, що представляє одну книгу в каталозі
class Book
  attr_accessor :title, :authors, :genres, :publisher, :published_date, :pages, :rating, :status

  # Ініціалізація нового об'єкта книги
  # Статус за замовчуванням — "want_to_read"
  def initialize(title, authors, genres, publisher, published_date, pages, rating)
    @title          = title
    @authors        = authors           # масив рядків
    @genres         = genres            # масив рядків
    @publisher      = publisher
    @published_date = published_date    # рядок формату "РРРР-ММ-ДД"
    @pages          = pages             # Integer
    @rating         = rating            # Float
    @status         = "want_to_read"    # want_to_read / reading / read
  end

  # Конвертація об'єкта у хеш для JSON-серіалізації
  def to_h
    {
      title:          @title,
      authors:        @authors,
      genres:         @genres,
      publisher:      @publisher,
      published_date: @published_date,
      pages:          @pages,
      rating:         @rating,
      status:         @status
    }
  end

  # Відновлення об'єкта Book з хешу (використовується при завантаженні з JSON)
  # self. означає, що це метод класу, а не екземпляра — викликається як Book.from_h(hash)
  def self.from_h(hash)
    # Підтримуємо і символьні (:title) і рядкові ("title") ключі
    get = ->(sym) { hash[sym] || hash[sym.to_s] }

    book = new(
      get.call(:title),
      get.call(:authors),
      get.call(:genres),
      get.call(:publisher),
      get.call(:published_date),
      get.call(:pages),
      get.call(:rating)
    )
    book.status = get.call(:status) || "want_to_read"
    book
  end

  # Рядкове представлення книги (використовується при виведенні результатів пошуку)
  def to_s
    "\"#{@title}\" — #{@authors.join(', ')} | #{@pages} стор. | рейтинг: #{@rating} | #{@status}"
  end
end
