require "rails_helper"

RSpec.describe "Books", type: :request do

  let(:user)       { create(:user) }
  let(:other_user) { create(:user) }
  let(:genre)      { create(:genre) }

  # Хелпер для входу через Devise (без Capybara)
  def sign_in_as(u)
    post user_session_path, params: {
      user: { email: u.email, password: "password123" }
    }
  end

  # ── Неавторизований користувач ───────────────────────────────────────────

  describe "GET /books без входу" do
    it "перенаправляє на сторінку входу" do
      get books_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "GET /books/new без входу" do
    it "перенаправляє на сторінку входу" do
      get new_book_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  # ── Авторизований користувач ─────────────────────────────────────────────

  describe "POST /books авторизованим користувачем" do
    before { sign_in_as(user) }

    it "створює книгу і прив'язує до поточного користувача" do
      expect {
        post books_path, params: {
          book: {
            title:          "Нова тестова книга",
            published_date: "2022-01-01",
            pages:          250,
            rating:         8.0,
            status:         "want_to_read",
            genre_id:       genre.id
          }
        }
      }.to change(Book, :count).by(1)

      book = Book.last
      expect(book.user).to eq(user)
      expect(response).to redirect_to(book_path(book))
    end

    it "не створює книгу з некоректними даними" do
      expect {
        post books_path, params: { book: { title: "", published_date: nil } }
      }.not_to change(Book, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  # ── Авторизація (перевірка власника) ────────────────────────────────────

  describe "DELETE /books/:id чужої книги" do
    let!(:other_book) { create(:book, user: other_user) }

    before { sign_in_as(user) }

    it "не дозволяє видалити і перенаправляє з повідомленням про помилку" do
      expect {
        delete book_path(other_book)
      }.not_to change(Book, :count)

      expect(response).to redirect_to(books_path)
      follow_redirect!
      expect(response.body).to include("Ви не маєте доступу")
    end
  end

  describe "PATCH /books/:id чужої книги" do
    let!(:other_book) { create(:book, user: other_user) }

    before { sign_in_as(user) }

    it "не дозволяє оновити і перенаправляє з повідомленням про помилку" do
      patch book_path(other_book), params: { book: { title: "Підмінна назва" } }

      expect(response).to redirect_to(books_path)
      expect(other_book.reload.title).not_to eq("Підмінна назва")
    end
  end

end
