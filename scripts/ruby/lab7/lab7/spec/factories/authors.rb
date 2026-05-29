FactoryBot.define do
  factory :author do
    sequence(:name) { |n| "Автор #{n}" }
    country    { "Україна" }
    birth_year { 1980 }

    association :book
  end
end
