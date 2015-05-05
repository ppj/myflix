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

  resources :queue_items, only: [:create, :destroy]
  get  'my_queue', to: 'queue_items#index'
  post 'update_queue', to: 'queue_items#update_queue'

  get '/genre/:id', to: 'categories#show', as: 'category'

  get 'people', to: 'followings#index'
  resources :followings, only: [:create, :destroy]
end
