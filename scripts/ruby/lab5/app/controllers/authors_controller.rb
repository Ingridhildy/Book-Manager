class AuthorsController < ApplicationController
  before_action :set_author, only: %i[show edit update destroy]

  def index
    @authors = Author.all.order(:name)
  end

  def show; end

  def new
    @author = Author.new
  end

  def create
    @author = Author.new(author_params)
    if @author.save
      redirect_to book_path(@author.book_id), notice: "Автора додано."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @author.update(author_params)
      redirect_to book_path(@author.book_id), notice: "Автора оновлено."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    book_id = @author.book_id
    @author.destroy
    redirect_to book_path(book_id), notice: "Автора видалено.", status: :see_other
  end

  private

  def set_author
    @author = Author.find(params[:id])
  end

  def author_params
    params.require(:author).permit(:name, :book_id)
  end
end
