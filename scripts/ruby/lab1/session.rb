require_relative 'books'

DATA_FILE = File.expand_path('collection.json', __dir__)

# Load existing collection from file, or start fresh
$collection = load_from_json(DATA_FILE)
$collection = {} if $collection.empty?

puts "Завантажено #{$collection.size} книг з #{DATA_FILE}"
puts ""
puts "Доступні команди:"
puts "  add({ title:, authors:, genres:, main_characters:, publisher:, published_date:, pages:, rating:, status: })"
puts "  update(id, { field: value })   -- редагувати книгу"
puts "  remove(id)                     -- видалити книгу"
puts "  list                           -- показати всі книги"
puts "  find_title('запит')            -- пошук за назвою"
puts "  find_author('автор')           -- пошук за автором"
puts "  find_genre('жанр')             -- фільтр за жанром"
puts "  find_status('статус')          -- фільтр за статусом"
puts "  find_character('персонаж')     -- пошук за персонажем"
puts "  save                           -- зберегти зміни у файл"
puts "-" * 50

def save
  save_to_json($collection, DATA_FILE)
  puts "Збережено #{$collection.size} книг у #{DATA_FILE}"
end

def add(book_data)      = add_book($collection, book_data)
def update(id, data)    = edit_book($collection, id, data)
def remove(id)          = delete_book($collection, id)
def list                = list_books($collection)
def find_title(q)       = find_by_title($collection, q)
def find_author(q)      = find_by_author($collection, q)
def find_genre(g)       = filter_by_genre($collection, g)
def find_status(s)      = filter_by_status($collection, s)
def find_character(c)   = find_by_main_character($collection, c)
