require "rails_helper"

RSpec.describe Book, type: :model do

  # ── Фікстура за замовчуванням ────────────────────────────────────────────
  subject(:book) { build(:book) }

  # =========================================================================
  # ВАЛІДАЦІЇ
  # =========================================================================

  describe "валідація title" do
    it "є валідним з коректним заголовком" do
      expect(book).to be_valid
    end

    it "не валідний без title" do
      book.title = nil
      expect(book).not_to be_valid
      expect(book.errors[:title]).to include("can't be blank")
    end

    it "не валідний якщо title коротший за 3 символи" do
      book.title = "AB"
      expect(book).not_to be_valid
      expect(book.errors[:title]).to be_present
    end

    it "не валідний якщо title довший за 200 символів" do
      book.title = "A" * 201
      expect(book).not_to be_valid
    end

    it "валідний з title рівно 3 символи" do
      book.title = "ABC"
      expect(book).to be_valid
    end

    it "валідний з title рівно 200 символів" do
      book.title = "A" * 200
      expect(book).to be_valid
    end
  end

  # -------------------------------------------------------------------------

  describe "валідація pages" do
    it "є валідним без pages (allow_nil)" do
      book.pages = nil
      expect(book).to be_valid
    end

    it "не валідний з pages = 0" do
      book.pages = 0
      expect(book).not_to be_valid
      expect(book.errors[:pages]).to be_present
    end

    it "не валідний з від'ємними pages" do
      book.pages = -5
      expect(book).not_to be_valid
    end

    it "не валідний з pages > 10 000" do
      book.pages = 10_001
      expect(book).not_to be_valid
    end

    it "валідний з pages = 10 000" do
      book.pages = 10_000
      expect(book).to be_valid
    end

    it "не валідний якщо pages — дробове число" do
      book.pages = 3.5
      expect(book).not_to be_valid
    end
  end

  # -------------------------------------------------------------------------

  describe "кастомна валідація published_date" do
    it "не валідний з датою у майбутньому" do
      book.published_date = Date.today + 1
      expect(book).not_to be_valid
      expect(book.errors[:published_date]).to include("не може бути у майбутньому")
    end

    it "валідний з сьогоднішньою датою" do
      book.published_date = Date.today
      expect(book).to be_valid
    end

    it "валідний з датою у минулому" do
      book.published_date = Date.new(2000, 1, 1)
      expect(book).to be_valid
    end

    it "не валідний без published_date" do
      book.published_date = nil
      expect(book).not_to be_valid
    end
  end

  # =========================================================================
  # SCOPES
  # =========================================================================

  describe ".read_books" do
    it "повертає лише прочитані книги" do
      read_book    = create(:book, status: :read)
      planned_book = create(:book, status: :want_to_read)

      expect(Book.read_books).to include(read_book)
      expect(Book.read_books).not_to include(planned_book)
    end
  end

  describe ".planned" do
    it "повертає лише заплановані книги (want_to_read)" do
      planned  = create(:book, status: :want_to_read)
      reading  = create(:book, status: :reading)

      expect(Book.planned).to include(planned)
      expect(Book.planned).not_to include(reading)
    end
  end

  describe ".highly_rated" do
    it "повертає книги з рейтингом >= 8" do
      high   = create(:book, rating: 9.0)
      border = create(:book, rating: 8.0)
      low    = create(:book, rating: 6.0)

      expect(Book.highly_rated).to include(high, border)
      expect(Book.highly_rated).not_to include(low)
    end
  end

  describe ".recent_5_years" do
    it "повертає книги за останні 5 років" do
      recent = create(:book, published_date: 2.years.ago)
      old    = create(:book, published_date: 10.years.ago)

      expect(Book.recent_5_years).to include(recent)
      expect(Book.recent_5_years).not_to include(old)
    end
  end

  # =========================================================================
  # АСОЦІАЦІЇ
  # =========================================================================

  describe "асоціації" do
    it "belongs_to user" do
      assoc = Book.reflect_on_association(:user)
      expect(assoc.macro).to eq(:belongs_to)
    end

    it "belongs_to genre" do
      assoc = Book.reflect_on_association(:genre)
      expect(assoc.macro).to eq(:belongs_to)
    end

    it "has_many authors" do
      assoc = Book.reflect_on_association(:authors)
      expect(assoc.macro).to eq(:has_many)
    end

    it "has_many taggings" do
      assoc = Book.reflect_on_association(:taggings)
      expect(assoc.macro).to eq(:has_many)
    end

    it "has_many tags through taggings" do
      assoc = Book.reflect_on_association(:tags)
      expect(assoc.macro).to eq(:has_many)
      expect(assoc.options[:through]).to eq(:taggings)
    end

    it "видаляє авторів при видаленні книги (dependent: :destroy)" do
      book   = create(:book)
      author = create(:author, book: book)

      expect { book.destroy }.to change(Author, :count).by(-1)
    end
  end

end
