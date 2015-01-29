Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  get '/home', to: 'videos#index'

  get '/video/:id', to: 'videos#show', as: 'video'

  get '/genre/:id', to: 'categories#show', as: 'category'

  get '/videos/search', to: 'videos#search'
end
