Rails.application.routes.draw do

  devise_for :users
  root "posts#index"
  get "pricing", to: "static_pages#pricing"
  resources :posts
  
end
