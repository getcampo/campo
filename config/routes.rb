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

  resources :forums do
    collection do
      post 'validate/:attribute', to: 'forums#validate', constraints: { attribute: /name|slug/ }
    end
  end
  resources :topics, only: [:show, :new, :create, :edit, :update]
  resources :comments, only: [:create, :edit, :update]
  resources :attachments, only: [:create]
  resource :preview, only: [:create]

  namespace :settings do
    resource :account, only: [:show, :update] do
      post 'validate/:attribute', to: 'accounts#validate', constraints: { attribute: /name|username|email/ }
    end
    resource :password, only: [:show, :update]
  end

  if Rails.env.development?
    get '/ui', to: 'ui#index'
  end
end
