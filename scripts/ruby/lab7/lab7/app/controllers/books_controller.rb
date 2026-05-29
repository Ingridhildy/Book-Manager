class BooksController < ApplicationController
  # Частина 1: усі дії вимагають входу
  before_action :authenticate_user!

  before_action :set_book,     only: %i[show edit update destroy]
  # Частина 2: лише власник може редагувати/видаляти
  before_action :check_owner!, only: %i[edit update destroy]

  # GET /books — лише книги поточного користувача
  def index
    @books = current_user.books.includes(:genre, :tags).order(:title)
  end

  # GET /books/read
  def read
    @books = current_user.books.read_books.includes(:genre, :tags).order(:title)
  end

  # GET /books/:id
  def show
    # @book вже завантажена через set_book
    # @book.user — автор запису (відображається у шаблоні)
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # POST /books
  def create
    # Частина 1: автоматично прив'язуємо до current_user
    @book = current_user.books.build(book_params)

    if @book.save
      redirect_to @book, notice: "Книгу успішно додано."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /books/:id/edit
  def edit; end

  # PATCH/PUT /books/:id
  def update
    if @book.update(book_params)
      redirect_to @book, notice: "Книгу успішно оновлено."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /books/:id
  def destroy
    @book.destroy
    redirect_to books_path, notice: "Книгу видалено.", status: :see_other
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  # Частина 2: перевірка власника
  def check_owner!
    unless @book.user == current_user
      redirect_to books_path, alert: "Ви не маєте доступу до цього запису."
    end
  end

  def book_params
    params.require(:book).permit(
      :title, :genre_id, :publisher, :published_date,
      :pages, :rating, :status,
      tag_ids: []
    )
  end
end
