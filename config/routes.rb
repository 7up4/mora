Rails.application.routes.draw do
  devise_for :readers
  resources :readers
  resources :books do
    resources :authors
    resources :publishers
    member do
      get :epub_reader
    end
  end
  resources :publishers
  resources :genres
  resources :authors

  root to: "books#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
