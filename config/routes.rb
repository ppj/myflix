Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: 'pages#front'

  resources :videos, only: [:show] do
    collection do
      get 'search', to: 'videos#search'
    end
  end

  get  'sign_in' , to: 'sessions#new'
  post 'sign_in',  to: 'sessions#create'
  get  'register', to: 'users#new'

  resources :users, only: [:create]

  get '/genre/:id', to: 'categories#show', as: 'category'
end
