require_relative 'book'
require_relative 'book_manager'

manager = BookManager.new

# автозавантаження
begin
  manager.load_from_yaml("books.yaml")
rescue
  begin
    manager.load_from_json("books.json")
  rescue
    puts "Починаємо з порожньої колекції"
  end
end

begin
  loop do
    puts
    puts "1. Додати книгу"
    puts "2. Показати всі книги"
    puts "3. Видалити книгу"
    puts "4. Пошук за назвою"
    puts "5. Фільтр за жанром"
    puts "6. Фільтр за статусом"
    puts "0. Вихід"

    choice = gets.chomp.to_i

    case choice

    when 1
      puts "Назва:"
      title = gets.chomp

      puts "Автори (через кому):"
      authors = gets.chomp.split(",")

      puts "Жанри:"
      genres = gets.chomp.split(",")

      puts "Видавництво:"
      publisher = gets.chomp

      puts "Дата:"
      published_date = gets.chomp

      puts "Сторінки:"
      pages = gets.chomp.to_i

      puts "Рейтинг:"
      rating = gets.chomp.to_f

      book = Book.new(title, authors, genres, publisher, published_date, pages, rating)

      manager.add_book(book)

    when 2
      manager.list_books

    when 3
      puts "ID книги:"
      id = gets.chomp.to_i
      manager.delete_book(id)

    when 4
      puts "Назва для пошуку:"
      query = gets.chomp
      puts manager.find_by_title(query)

    when 5
      puts "Жанр:"
      genre = gets.chomp
      puts manager.filter_by_genre(genre)

    when 6
      puts "Статус:"
      status = gets.chomp
      puts manager.filter_by_status(status)

    when 0
      break

    else
      puts "Невірний вибір"
    end
  end

ensure
  manager.save_to_yaml("books.yaml")
  puts "Дані збережено"
end