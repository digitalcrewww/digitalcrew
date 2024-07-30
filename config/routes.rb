Rails.application.routes.draw do
  root 'dashboard#index'

  # Authentification
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # Setup
  get 'setup', to: 'setup#new'
  post 'setup', to: 'setup#create'

  namespace :admin do
    resources :pilots, only: %i[index update destroy]
  end
end
