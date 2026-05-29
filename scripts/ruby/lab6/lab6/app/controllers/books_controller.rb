class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy]

  # GET /books
  def index
    @books = Book.includes(:genre, :tags).order(:title)
  end

  # GET /books/read
  def read
    @books = Book.read.includes(:genre, :tags).order(:title)
  end

  # GET /books/:id
  def show
    # @book.authors та @book.tags доступні через асоціації
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # POST /books
  def create
    @book = Book.new(book_params)

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

  def book_params
    params.require(:book).permit(
      :title, :genre_id, :publisher, :published_date,
      :pages, :rating, :status,
      tag_ids: []   # Частина 3: many-to-many через чекбокси
    )
  end
end
