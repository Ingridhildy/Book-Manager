require 'json'
require 'yaml'
require_relative 'book'

class BookManager

  def initialize
    @collection = {}
  end

  # додавання книги
  def add_book(book)
    id = @collection.keys.max.to_i + 1
    @collection[id] = book
  end

  # редагування книги
  def edit_book(id, new_data)
    book = @collection[id]

    if book.nil?
      puts "Книга не знайдена"
      return
    end

    new_data.each do |key, value|
      book.send("#{key}=", value) if book.respond_to?("#{key}=")
    end
  end

  # видалення
  def delete_book(id)
    if @collection.delete(id)
      puts "Книга видалена"
    else
      puts "Книга не знайдена"
    end
  end

  # список книг
  def list_books
    @collection.each do |id, book|
      puts "ID: #{id}"
      puts "Назва: #{book.title}"
      puts "Автори: #{book.authors.join(", ")}"
      puts "Жанри: #{book.genres.join(", ")}"
      puts "Видавництво: #{book.publisher}"
      puts "Дата: #{book.published_date}"
      puts "Сторінки: #{book.pages}"
      puts "Рейтинг: #{book.rating}"
      puts "Статус: #{book.status}"
      puts "-" * 40
    end
  end

  # пошук за назвою
  def find_by_title(query)
    @collection.select do |_, book|
      book.title.downcase.include?(query.downcase)
    end
  end

  # фільтр за жанром
  def filter_by_genre(genre)
    @collection.select do |_, book|
      book.genres.include?(genre)
    end
  end

  # фільтр за статусом
  def filter_by_status(status)
    @collection.select do |_, book|
      book.status == status
    end
  end

  # ------------------------
  # YAML серіалізація
  # ------------------------

  def save_to_yaml(filename)
    File.write(filename, YAML.dump(@collection))
  end

  def load_from_yaml(filename)
    @collection = YAML.load_file(filename)
  rescue Errno::ENOENT
    puts "YAML файл не знайдено"
  end

  # ------------------------
  # JSON серіалізація
  # ------------------------

  def save_to_json(filename)
    data = @collection.transform_values(&:to_h)
    File.write(filename, JSON.pretty_generate(data))
  end

  def load_from_json(filename)
    data = JSON.parse(File.read(filename), symbolize_names: true)

    @collection = data.transform_values do |book_hash|
      Book.from_h(book_hash)
    end

  rescue Errno::ENOENT
    puts "JSON файл не знайдено"
  end
end