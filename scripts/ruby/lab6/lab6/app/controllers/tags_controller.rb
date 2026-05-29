class TagsController < ApplicationController
  before_action :set_tag, only: %i[show edit update destroy]

  # GET /tags
  def index
    @tags = Tag.all.order(:name)
  end

  # GET /tags/:id
  def show
    @books = @tag.books.order(:title)
  end

  # GET /tags/new
  def new
    @tag = Tag.new
  end

  # POST /tags
  def create
    @tag = Tag.new(tag_params)

    if @tag.save
      redirect_to @tag, notice: "Тег успішно створено."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /tags/:id/edit
  def edit; end

  # PATCH/PUT /tags/:id
  def update
    if @tag.update(tag_params)
      redirect_to @tag, notice: "Тег успішно оновлено."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /tags/:id
  def destroy
    @tag.destroy
    redirect_to tags_path, notice: "Тег видалено.", status: :see_other
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name)
  end
end
