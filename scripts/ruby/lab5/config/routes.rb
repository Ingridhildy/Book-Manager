Rails.application.routes.draw do
  resources :genres

  resources :books do
    collection do
      get :read
      get :recent
    end
  end

  resources :authors

  root "books#index"
  get "up" => "rails/health#show", as: :rails_health_check
end
