FactoryBot.define do
  factory :book do
    sequence(:title) { |n| "Книга #{n}" }
    published_date { Date.new(2020, 6, 15) }   # минуле — проходить кастомну валідацію
    pages          { 320 }
    rating         { 7.5 }
    status         { :want_to_read }

    association :user
    association :genre
  end
end
