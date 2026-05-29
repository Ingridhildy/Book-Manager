Rails.application.routes.draw do
  root "books#index"

  devise_for :users

  resources :books do
    collection { get :read }
    resources :authors, only: %i[new create edit update destroy]
  end

  resources :genres
  resources :tags

  # Бонус: колаборації
  resources :collaborations, only: %i[create destroy]
end
