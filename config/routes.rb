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

  resources :forums, only: [:index, :show] do
    collection do
      post 'validate/:attribute', to: 'forums#validate', constraints: { attribute: /name|slug/ }
    end
  end

  concern :trashable do
    member do
      put :trash
    end
  end

  resources :topics, only: [:show, :new, :create, :edit, :update], concerns: [:trashable]
  resources :posts, only: [:create, :edit, :update], concerns: [:trashable]
  resources :comments, only: [:create, :edit, :update], concerns: [:trashable]
  resources :attachments, only: [:create]
  resource :preview, only: [:create]
  resources :notifications, only: [:index]

  namespace :settings do
    resource :account, only: [:show, :update] do
      post 'validate/:attribute', to: 'accounts#validate', constraints: { attribute: /name|username|email/ }
    end
    resource :password, only: [:show, :update]
  end

  namespace :admin do
    root to: 'dashboard#index'
    resources :forums
  end

  if Rails.env.development?
    get '/ui', to: 'ui#index'
    get '/scrollbar', to: 'ui#scrollbar'
  end
end
