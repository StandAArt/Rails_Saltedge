Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  authenticated :user do
    root 'user#show', :as => :authenticated_root
  end

  root "home#index"

  resources :customers
  # Defines the root path route ("/")
  # root "articles#index"
end
