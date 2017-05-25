Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  devise_for :users

  root "static_pages#home"

  resources :reviews do
    resources :comments
  end
  resources :train_texts
  resources :searches
  resources :users
  resources :clipped_reviews, controller: "clipped_reviews"

  namespace :admin do
    root "static_pages#home"
    resources :trains
    resources :train_texts
    resources :train_reviews
    resources :test_reviews
    resources :reviews
    resources :users
  end
end
