Rails.application.routes.draw do
  root "books#index"

  resources :books do
    collection { get :read }
    resources :authors, only: %i[new create edit update destroy]
  end

  resources :genres
  resources :tags
end
