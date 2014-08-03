require "resque_web"

Rails.application.routes.draw do
  root 'home#index'
  resources :r_packages, only: [:show]
  mount ResqueWeb::Engine => "/resque-web"
end
