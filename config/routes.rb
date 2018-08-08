Rails.application.routes.draw do
  root 'home#index'

  get 'home/index'
  resources :things, only: [:index, :destroy]
  resources :policies, only: [:index, :destroy]
  resources :certs, only: [:index, :destroy]
end
