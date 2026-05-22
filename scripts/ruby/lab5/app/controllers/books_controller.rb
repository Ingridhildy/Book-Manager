class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy]

  # GET /books
  def index
    @books = Book.all.order(:title)
  end

  # GET /books/read — прочитані книги (використовує scope)
  def read
    @books = Book.read_books.order(:title)
    render :index
  end

  # GET /books/recent — книги за останні 5 років (використовує scope)
  def recent
    @books = Book.recent.order(published_date: :desc)
  end

  # GET /books/:id
  def show
    @authors = Author.where(book_id: @book.id)
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

  def book_params
    params.require(:book).permit(:title, :genre, :publisher, :published_date, :pages, :rating, :status, :isbn)
  end

  def set_book
    @book = Book.find(params[:id])
  end
end
