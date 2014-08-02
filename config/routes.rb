Rails.application.routes.draw do
  root 'home#index'
  resources :r_packages, only: [:show]
end
