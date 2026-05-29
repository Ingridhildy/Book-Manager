class AuthorsController < ApplicationController
  before_action :set_book
  before_action :set_author, only: %i[edit update destroy]

  # GET /books/:book_id/authors/new
  def new
    @author = Author.new
  end

  # POST /books/:book_id/authors
  def create
    @author = @book.authors.build(author_params)

    if @author.save
      redirect_to @book, notice: "Автора успішно додано."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /books/:book_id/authors/:id/edit
  def edit; end

  # PATCH /books/:book_id/authors/:id
  def update
    if @author.update(author_params)
      redirect_to @book, notice: "Автора оновлено."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /books/:book_id/authors/:id
  def destroy
    @author.destroy
    redirect_to @book, notice: "Автора видалено.", status: :see_other
  end

  private

  def set_book
    @book = Book.find(params[:book_id])
  end

  def set_author
    @author = @book.authors.find(params[:id])
  end

  def author_params
    params.require(:author).permit(:name, :country, :birth_year)
  end
end
