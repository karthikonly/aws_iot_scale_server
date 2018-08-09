Rails.application.routes.draw do
  root 'home#index'

  get 'home/index'

  match '/api/get_credentials', to: 'home#get_credentials', via: [:get, :post]
  match '/api/issue_command', to: 'home#issue_command', via: [:get, :post]

  resources :things, only: [:index, :destroy]
  resources :policies, only: [:index, :destroy]
  resources :certs, only: [:index, :destroy]
end
