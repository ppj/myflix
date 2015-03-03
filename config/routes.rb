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

  get  'sign_in' , to: 'sessions#new'
  get  'sign_out', to: 'sessions#destroy'
  get  'home',     to: 'pages#home'

  get  'register', to: 'users#new'

  resources :sessions, only: [:create]
  resources :users, only: [:create]

  get '/genre/:id', to: 'categories#show', as: 'category'
end
