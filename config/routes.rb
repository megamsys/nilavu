Cloudauth::Application.routes.draw do

  get "collaborate/display"

  root to: 'static_pages#home'

  match '/help',    to: 'static_pages#help'
  match '/about',   to: 'static_pages#about'
  match '/contact', to: 'static_pages#contact'
  match '/products', to: 'static_pages#products'
  match '/jobs', to: 'static_pages#jobs'
  match '/dev_center', to: 'static_pages#dev_center'
  match '/documentation', to: 'static_pages#documentation'

  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :identities

  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new'
  get "signout" => "sessions#destroy", :as => "signout"
  match '/signout', to: 'sessions#destroy', via: :delete

  match '/auth/:provider/callback', :to => 'sessions#create'

end