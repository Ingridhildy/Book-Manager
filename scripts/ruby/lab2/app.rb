require_relative 'book'
require_relative 'book_manager'

manager = BookManager.new

# Автозавантаження при старті: спочатку YAML, потім JSON, потім порожній стан
# YAML має пріоритет, бо він зберігається автоматично при виході
puts "Завантаження даних..."
yaml_loaded = false

begin
  manager.load_from_yaml("books.yaml")
  yaml_loaded = true
rescue Errno::ENOENT
  # YAML не знайдено — пробуємо JSON
end

unless yaml_loaded
  begin
    manager.load_from_json("books.json")
  rescue Errno::ENOENT
    puts "Починаємо з порожньої колекції"
  end
end

# Основний цикл програми
# ensure гарантує збереження навіть при помилці або Ctrl+C
begin
  loop do
    puts
    puts "======= КАТАЛОГ КНИГ ======="
    puts "1. Додати книгу"
    puts "2. Показати всі книги"
    puts "3. Редагувати книгу"
    puts "4. Видалити книгу"
    puts "5. Пошук за назвою"
    puts "6. Фільтр за жанром"
    puts "7. Фільтр за статусом"
    puts "0. Вихід"
    puts "============================="
    print "Ваш вибір: "

    choice = gets.chomp.to_i

    case choice

    when 1
      print "Назва: "
      title = gets.chomp

      print "Автори (через кому): "
      authors = gets.chomp.split(",").map(&:strip)

      print "Жанри (через кому): "
      genres = gets.chomp.split(",").map(&:strip)

      print "Видавництво: "
      publisher = gets.chomp

      print "Дата публікації (РРРР-ММ-ДД): "
      published_date = gets.chomp

      print "Кількість сторінок: "
      pages = gets.chomp.to_i

      print "Рейтинг (0.0 - 10.0): "
      rating = gets.chomp.to_f

      book = Book.new(title, authors, genres, publisher, published_date, pages, rating)
      manager.add_book(book)

    when 2
      manager.list_books

    when 3
      print "ID книги для редагування: "
      id = gets.chomp.to_i

      print "Поле для зміни (title / authors / genres / publisher / published_date / pages / rating / status): "
      field = gets.chomp.strip

      print "Нове значення: "
      value = gets.chomp

      # Конвертуємо значення до потрібного типу
      value = case field
              when "pages"              then value.to_i
              when "rating"             then value.to_f
              when "authors", "genres"  then value.split(",").map(&:strip)
              else value
              end

      manager.edit_book(id, { field.to_sym => value })

    when 4
      print "ID книги для видалення: "
      id = gets.chomp.to_i
      manager.delete_book(id)

    when 5
      print "Пошуковий запит (назва): "
      query = gets.chomp
      results = manager.find_by_title(query)
      manager.print_results(results)

    when 6
      print "Жанр: "
      genre = gets.chomp.strip
      results = manager.filter_by_genre(genre)
      manager.print_results(results)

    when 7
      puts "Доступні статуси: want_to_read / reading / read"
      print "Статус: "
      status = gets.chomp.strip
      results = manager.filter_by_status(status)
      manager.print_results(results)

    when 0
      puts "До побачення!"
      break

    else
      puts "Невірний вибір. Спробуйте ще раз."
    end
  end

ensure
  # Автозбереження у YAML при будь-якому виході (навіть при Ctrl+C або помилці)
  manager.save_to_yaml("books.yaml")
  puts "Дані збережено. До побачення!"
end
