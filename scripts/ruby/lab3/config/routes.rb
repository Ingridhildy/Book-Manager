Rails.application.routes.draw do
  # Scaffold-маршрути для допоміжної моделі Genre (генерує 7 стандартних маршрутів)
  resources :genres

  # Маршрути для основної моделі Book (додані вручну)
  # resources генерує: index, show, new, create, edit, update, destroy
  # Кастомний маршрут /books/read — показує лише прочитані книги
  resources :books do
    collection do
      get :read
    end
  end

  # Кореневий маршрут
  root "books#index"

  # Перевірка стану додатку
  get "up" => "rails/health#show", as: :rails_health_check
end
