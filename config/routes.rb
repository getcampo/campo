Rails.application.routes.draw do
  root to: 'home#index'

  namespace :auth do
    resource :email, only: [:show, :create]
  end

  get '/auth/:provider/callback', to: 'sessions#create'
end
