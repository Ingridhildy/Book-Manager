class User < ApplicationRecord
  # Devise модулі — стандартний набір
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Книги, які користувач додав (основна власність)
  has_many :books, dependent: :destroy

  # Бонус: книги, у яких користувач — співавтор/колаборатор
  has_many :collaborations, dependent: :destroy
  has_many :collaborated_books, through: :collaborations, source: :book
end
