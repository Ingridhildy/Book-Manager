require 'date'

class Book
  attr_accessor :title, :authors, :genres, :publisher, :published_date, :pages, :rating, :status

  def initialize(title, authors, genres, publisher, published_date, pages, rating)
    @title = title
    @authors = authors
    @genres = genres
    @publisher = publisher
    @published_date = published_date
    @pages = pages
    @rating = rating
    @status = "want_to_read"
  end

  # конвертація об'єкта у хеш (для JSON)
  def to_h
    {
      title: @title,
      authors: @authors,
      genres: @genres,
      publisher: @publisher,
      published_date: @published_date,
      pages: @pages,
      rating: @rating,
      status: @status
    }
  end

  # створення об'єкта з хешу
  def self.from_h(hash)
    book = Book.new(
      hash[:title],
      hash[:authors],
      hash[:genres],
      hash[:publisher],
      hash[:published_date],
      hash[:pages],
      hash[:rating]
    )

    book.status = hash[:status]
    book
  end
end