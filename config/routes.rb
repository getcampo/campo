Rails.application.routes.draw do
  root to: 'home#index'

  resources :users, only: [:new, :create] do
    collection do
      post 'validate/:attribute', to: 'users#validate', constraints: { attribute: /name|username|email|password/ }
    end
  end
  resource :password_reset, only: [:show, :create, :edit, :update]

  namespace :auth do
    resource :email, only: [:show, :create]
  end

  resource :session, only: [:new, :create, :destroy]
  get '/auth/:provider/callback', to: 'sessions#create', as: :auth_callback

  if Rails.env.development?
    get '/ui', to: 'ui#index'
  end
end
