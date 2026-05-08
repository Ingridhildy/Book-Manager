require 'json'
require 'yaml'
require_relative 'book'

# Клас-менеджер для керування колекцією книг
class BookManager

  def initialize
    # Колекція зберігається як хеш: { Integer => Book }
    @collection = {}
  end

  # -------------------------
  # CRUD операції
  # -------------------------

  # Додати нову книгу; id генерується автоматично
  def add_book(book)
    id = (@collection.keys.max || 0) + 1
    @collection[id] = book
    puts "Книгу додано з ID: #{id}"
  end

  # Редагувати поля книги за id
  # new_data — хеш вигляду { field: value }, наприклад { rating: 9.0, status: "read" }
  def edit_book(id, new_data)
    book = @collection[id]

    if book.nil?
      puts "Книга з ID #{id} не знайдена"
      return
    end

    new_data.each do |key, value|
      # send дозволяє динамічно викликати сетер: book.title = value
      if book.respond_to?("#{key}=")
        book.send("#{key}=", value)
      else
        puts "Поле '#{key}' не існує — пропущено"
      end
    end
    puts "Книгу з ID #{id} оновлено"
  end

  # Видалити книгу за id
  def delete_book(id)
    if @collection.delete(id)
      puts "Книгу з ID #{id} видалено"
    else
      puts "Книга з ID #{id} не знайдена"
    end
  end

  # Вивести всі книги у зручному форматі
  def list_books
    if @collection.empty?
      puts "Колекція порожня"
      return
    end

    @collection.each do |id, book|
      puts "ID: #{id}"
      puts "Назва: #{book.title}"
      puts "Автори: #{book.authors.join(', ')}"
      puts "Жанри: #{book.genres.join(', ')}"
      puts "Видавництво: #{book.publisher}"
      puts "Дата публікації: #{book.published_date}"
      puts "Сторінки: #{book.pages}"
      puts "Рейтинг: #{book.rating}"
      puts "Статус: #{book.status}"
      puts "-" * 40
    end
  end

  # -------------------------
  # Пошук та фільтрація
  # -------------------------

  # Пошук за частиною назви (регістронезалежний)
  def find_by_title(query)
    @collection.select do |_, book|
      book.title.downcase.include?(query.downcase)
    end
  end

  # Фільтр за жанром (точний збіг)
  def filter_by_genre(genre)
    @collection.select do |_, book|
      book.genres.include?(genre)
    end
  end

  # Фільтр за статусом читання: "want_to_read" / "reading" / "read"
  def filter_by_status(status)
    @collection.select do |_, book|
      book.status == status
    end
  end

  # Виведення результатів пошуку/фільтрації у форматованому вигляді
  def print_results(results)
    if results.empty?
      puts "Нічого не знайдено"
    else
      results.each do |id, book|
        puts "[#{id}] #{book}"
      end
    end
  end

  # -------------------------
  # YAML серіалізація (нативна — зберігає об'єкти напряму)
  # -------------------------

  # YAML може зберігати Ruby-об'єкти без конвертації у хеш
  def save_to_yaml(filename)
    File.write(filename, YAML.dump(@collection))
    puts "Збережено у #{filename}"
  end

  def load_from_yaml(filename)
    @collection = YAML.load_file(filename) || {}
    return false if @collection.empty?
    puts "Завантажено #{@collection.size} книг з #{filename}"
    true
  rescue Errno::ENOENT
    puts "YAML файл '#{filename}' не знайдено"
    false
  end

  # -------------------------
  # JSON серіалізація (через to_h / from_h)
  # JSON не підтримує Ruby-об'єкти напряму — потрібна ручна конвертація
  # -------------------------

  def save_to_json(filename)
    # Перетворюємо кожен об'єкт Book на хеш перед записом
    data = @collection.transform_values(&:to_h)
    File.write(filename, JSON.pretty_generate(data))
    puts "Збережено у #{filename}"
  end

  def load_from_json(filename)
    raw = JSON.parse(File.read(filename))

    # JSON ключі завжди рядки — конвертуємо назад у Integer для збереження типу
    @collection = raw.transform_keys(&:to_i).transform_values do |book_hash|
      # Відновлюємо об'єкт Book з хешу через self.from_h
      Book.from_h(book_hash)
    end
    return false if @collection.empty?
    puts "Завантажено #{@collection.size} книг з #{filename}"
    true
  rescue Errno::ENOENT
    puts "JSON файл '#{filename}' не знайдено"
    false
  end
end
