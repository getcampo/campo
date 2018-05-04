Rails.application.routes.draw do
  root to: 'home#index'

  resources :users, only: [:new, :create] do
    collection do
      post 'validate/:attribute', to: 'users#validate', constraints: { attribute: /name|username|email|password/ }
    end
  end
  resource :password_reset, only: [:show, :create, :edit, :update]
  resource :session, only: [:new, :create, :destroy]

  get '/auth/:provider/callback', to: 'auths#callback', as: :auth_callback
  namespace :auth do
    resources :users, only: [:new, :create]
  end

  resources :boards do
    collection do
      post 'validate/:attribute', to: 'boards#validate', constraints: { attribute: /name|slug/ }
    end
  end
  resources :topics

  if Rails.env.development?
    get '/ui', to: 'ui#index'
  end
end
