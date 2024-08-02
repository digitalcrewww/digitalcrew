Rails.application.routes.draw do
  root 'dashboard#index'
  # Authentication
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  # Setup
  get 'setup', to: 'setup#new'
  post 'setup', to: 'setup#create'

  scope module: 'pilot' do
    resources :pireps, only: %i[index create]
  end

  namespace :admin do
    resources :pilots, only: %i[index update destroy]
    resources :fleet, only: %i[index create update destroy]
    resources :multipliers, only: %i[index create update destroy]
  end
end
