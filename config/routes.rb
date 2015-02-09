Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: 'pages#front'

  resources :videos, only: [:show, :index] do
    collection do
      get 'search', to: 'videos#search'
    end
  end

  get  'sign_in' , to: 'sessions#new'
  post 'sign_in',  to: 'sessions#create'
  get  'sign_out', to: 'sessions#destroy'
  get  'home',     to: 'pages#home'

  get  'register', to: 'users#new'

  resources :users, only: [:create]

  get '/genre/:id', to: 'categories#show', as: 'category'
end
