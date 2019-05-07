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

  resources :categories, only: [:index, :show]

  concern :trashable do
    member do
      put :trash
    end
  end

  get 'topics/:id/(:number)', to: 'topics#show', as: 'topic', constraints: { id: /\d+/, number: /\d+/ }
  resources :topics, only: [:create, :edit, :update], concerns: [:trashable] do
    resource :subscription, only: [:update, :destroy]
  end
  resources :posts, only: [:show, :create, :edit, :update], concerns: [:trashable]
  resources :attachments, only: [:create]
  resource :preview, only: [:create]
  resources :notifications, only: [:index]

  namespace :settings do
    resource :account, only: [:show, :update] do
      post 'validate/:attribute', to: 'accounts#validate', constraints: { attribute: /name|username|email/ }
    end
    resource :password, only: [:show, :update]
  end

  get '/@:username', to: 'profile/topics#index', as: 'profile'
  scope '/@:username', module: 'profile', as: 'profile' do
    resources :posts, only: [:index]
  end

  namespace :admin do
    root to: 'dashboard#index'
    resources :forums
    resources :categories
  end

  if Rails.env.development?
    get '/ui/(:page)', to: 'ui#page'
  end
end
