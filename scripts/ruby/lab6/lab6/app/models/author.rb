class Author < ApplicationRecord
  belongs_to :book

  validates :name, presence: true
  validates :birth_year, numericality: { only_integer: true,
                                         greater_than: 1000,
                                         less_than_or_equal_to: Date.today.year },
                         allow_nil: true
end
