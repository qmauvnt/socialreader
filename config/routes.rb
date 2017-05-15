Rails.application.routes.draw do
  devise_for :users

  root "static_pages#home"

  resources :reviews do
    resources :comments
  end
  resources :searches

  namespace :admin do
    root "static_pages#home"
  end
end
