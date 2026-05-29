class CollaborationsController < ApplicationController
  before_action :authenticate_user!

  # POST /collaborations  (book_id у params)
  def create
    book = Book.find(params[:book_id])
    collaboration = book.collaborations.build(user: current_user)

    if collaboration.save
      redirect_to book, notice: "Вас додано як колаборатора."
    else
      redirect_to book, alert: collaboration.errors.full_messages.to_sentence
    end
  end

  # DELETE /collaborations/:id
  def destroy
    collaboration = current_user.collaborations.find(params[:id])
    book = collaboration.book
    collaboration.destroy
    redirect_to book, notice: "Колаборацію видалено."
  end
end
