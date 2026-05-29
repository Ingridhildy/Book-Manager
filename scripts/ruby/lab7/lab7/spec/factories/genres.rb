FactoryBot.define do
  factory :genre do
    sequence(:name) { |n| "Жанр #{n}" }
  end
end
