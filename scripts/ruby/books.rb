require 'json'
require 'yaml'

# add book
def add_book(collection, book_data)
  new_id = collection.keys.max.to_i + 1
  collection[new_id] = book_data
end

# edit book
def edit_book(collection, id, new_data)
  if collection.key?(id)
    collection[id].merge!(new_data)
  else
    puts "Книга з id #{id} не знайдена"
  end
end

# delete book
def delete_book(collection, id)
  if collection.delete(id)
    puts "Книга #{id} видалена"
  else
    puts "Книга з id #{id} не знайдена"
  end
end

# output all books
def list_books(collection)
  collection.each do |id, book|
    puts "ID: #{id}"
    puts "Назва: #{book[:title]}"
    puts "Автори: #{book[:authors].join(', ')}"
    puts "Жанри: #{book[:genres].join(', ')}"
    puts "Головні персонажі: #{book[:main_characters].join(', ')}"
    puts "Видавництво: #{book[:publisher]}"
    puts "Дата публікації: #{book[:published_date]}"
    puts "Сторінки: #{book[:pages]}"
    puts "Рейтинг: #{book[:rating]}"
    puts "Статус: #{book[:status]}"
    puts "-" * 40
  end
end

# find by title
def find_by_title(collection, query)
  collection.select do |_, book|
    book[:title].downcase.include?(query.downcase)
  end
end

# find by author
def find_by_author(collection, author_query)
  collection.select do |_, book|
    book[:authors].any? do |author|
      author.downcase.include?(author_query.downcase)
    end
  end
end

# filter by genre
def filter_by_genre(collection, genre)
  collection.select do |_, book|
    book[:genres].include?(genre)
  end
end

# filter by status
def filter_by_status(collection, status)
  collection.select do |_, book|
    book[:status] == status
  end
end

# find by main character
def find_by_main_character(collection, character)
  collection.select do |_, book|
    book[:main_characters].include?(character)
  end
end

# save to json
def save_to_json(collection, filename)
  File.write(filename, JSON.pretty_generate(collection))
end

# load from json
def load_from_json(filename)
  data = JSON.parse(File.read(filename), symbolize_names: true)
  # JSON зберігає ключі як рядки ("1", "2"), symbolize_names робить їх :"1", :"2"
  # Конвертуємо назад у Integer, щоб edit_book/delete_book знаходили записи за id
  data.transform_keys { |k| k.to_s.to_i }
rescue Errno::ENOENT
  puts "Файл #{filename} не знайдено"
  {}
end

# save to yaml
def save_to_yaml(collection, filename)
  File.write(filename, collection.to_yaml)
end

# load from yaml
def load_from_yaml(filename)
  YAML.load_file(filename)
rescue Errno::ENOENT
  puts "Файл #{filename} не знайдено"
  {}
end
