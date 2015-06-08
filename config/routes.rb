Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: 'pages#front'
  get 'home', to: 'videos#index'

  resources :videos, only: [:show, :index] do
    resources :reviews, only: [:create]
    collection do
      get 'search', to: 'videos#search'
    end
  end

  resources :sessions, only: [:create]
  get    'sign_in' , to: 'sessions#new'
  delete 'sign_out', to: 'sessions#destroy'

  resources :users, only: [:create, :show]
  get 'register', to: 'users#new'

  get 'forgot_password', to: 'forgot_passwords#new'
  resources :forgot_passwords, only: [:create]
  get 'confirm_password_reset', to: 'forgot_passwords#confirm'

  resources :reset_passwords, only: [:show, :create]

  resources :queue_items, only: [:create, :destroy]
  get  'my_queue', to: 'queue_items#index'
  post 'update_queue', to: 'queue_items#update_queue'

  get '/genre/:id', to: 'categories#show', as: 'category'

  get 'people', to: 'followings#index'
  resources :followings, only: [:create, :destroy]

  get '/invite', to: 'invitations#show', as: 'invite'
end
