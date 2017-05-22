Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  devise_for :users

  root "static_pages#home"

  resources :reviews do
    resources :comments
  end
  resources :train_texts

  resources :searches

  namespace :admin do
    root "static_pages#home"
    resources :trains
    resources :train_texts
    resources :train_reviews
    resources :test_reviews
  end
end
