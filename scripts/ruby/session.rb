require_relative 'books'

DATA_FILE = File.expand_path('collection.json', __dir__)

# Load existing collection from file, or start fresh
$collection = load_from_json(DATA_FILE)
$collection = {} if $collection.empty?

puts "Завантажено #{$collection.size} книг з #{DATA_FILE}"
puts "Доступні методи: add_book, edit_book, delete_book, list_books,"
puts "                 find_by_title, filter_by_genre, filter_by_status,"
puts "                 find_by_main_character, save"
puts "Використовуй \$collection як колекцію. Введи save, щоб зберегти зміни."
puts "-" * 50

# Shortcut: just type `save` to persist changes
def save
  save_to_json($collection, DATA_FILE)
  puts "Збережено #{$collection.size} книг у #{DATA_FILE}"
end

# Shortcuts that don't require passing $collection every time
def add(book_data)     = add_book($collection, book_data)
def edit(id, data)     = edit_book($collection, id, data)
def delete(id)         = delete_book($collection, id)
def list               = list_books($collection)
def find_title(q)      = find_by_title($collection, q)
def find_genre(g)      = filter_by_genre($collection, g)
def find_status(s)     = filter_by_status($collection, s)
def find_character(c)  = find_by_main_character($collection, c)
