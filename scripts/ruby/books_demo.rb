require_relative 'books'

puts "=== Book Collection Demo ===\n\n"

# Start with an empty collection
collection = {}

# Add some books
add_book(collection, {
  title: "Гаррі Поттер і Філософський камінь",
  authors: ["Дж. К. Роулінг"],
  genres: ["Фентезі", "Пригоди"],
  main_characters: ["Гаррі Поттер", "Герміона Ґрейнджер", "Рон Візлі"],
  publisher: "Bloomsbury",
  published_date: "1997-06-26",
  pages: 223,
  rating: 4.9,
  status: "прочитано"
})

add_book(collection, {
  title: "Володар перснів",
  authors: ["Дж. Р. Р. Толкін"],
  genres: ["Фентезі", "Епос"],
  main_characters: ["Фродо Беггінс", "Гендальф", "Арагорн"],
  publisher: "Allen & Unwin",
  published_date: "1954-07-29",
  pages: 1178,
  rating: 4.8,
  status: "хочу прочитати"
})

add_book(collection, {
  title: "1984",
  authors: ["Джордж Орвелл"],
  genres: ["Антиутопія", "Наукова фантастика"],
  main_characters: ["Вінстон Сміт", "Джулія"],
  publisher: "Secker & Warburg",
  published_date: "1949-06-08",
  pages: 328,
  rating: 4.7,
  status: "прочитано"
})

puts "--- Усі книги після додавання ---"
list_books(collection)

# Edit a book
puts "\n--- Редагуємо рейтинг книги 2 ---"
edit_book(collection, 2, { rating: 5.0 })
puts "Новий рейтинг книги 2: #{collection[2][:rating]}"

# Find by title
puts "\n--- Пошук за назвою 'гаррі' ---"
results = find_by_title(collection, "гаррі")
results.each { |id, b| puts "Знайдено: [#{id}] #{b[:title]}" }

# Filter by genre
puts "\n--- Фільтр за жанром 'Фентезі' ---"
results = filter_by_genre(collection, "Фентезі")
results.each { |id, b| puts "[#{id}] #{b[:title]}" }

# Filter by status
puts "\n--- Фільтр за статусом 'прочитано' ---"
results = filter_by_status(collection, "прочитано")
results.each { |id, b| puts "[#{id}] #{b[:title]}" }

# Find by character
puts "\n--- Пошук за персонажем 'Гендальф' ---"
results = find_by_main_character(collection, "Гендальф")
results.each { |id, b| puts "[#{id}] #{b[:title]}" }

# Save and load JSON
puts "\n--- Збереження та завантаження JSON ---"
save_to_json(collection, "/tmp/books.json")
puts "Збережено у /tmp/books.json"
loaded = load_from_json("/tmp/books.json")
puts "Завантажено #{loaded.size} книг з JSON"

# Save and load YAML
puts "\n--- Збереження та завантаження YAML ---"
save_to_yaml(collection, "/tmp/books.yaml")
puts "Збережено у /tmp/books.yaml"
loaded_yaml = load_from_yaml("/tmp/books.yaml")
puts "Завантажено #{loaded_yaml.size} книг з YAML"

# Delete a book
puts "\n--- Видаляємо книгу з id 1 ---"
delete_book(collection, 1)
delete_book(collection, 99) # non-existent

puts "\n--- Фінальна колекція ---"
list_books(collection)
