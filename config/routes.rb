Rails.application.routes.draw do
  root to: 'home#index'

  resources :users, only: [:new, :create]

  namespace :auth do
    resource :email, only: [:show, :create]
  end

  resource :session, only: [:new, :destroy]
  get '/auth/:provider/callback', to: 'sessions#create', as: :auth_callback

  if Rails.env.development?
    get '/ui', to: 'ui#index'
  end
end
