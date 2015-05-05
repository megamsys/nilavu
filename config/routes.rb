Nilavu::Application.routes.draw do

  root :to => 'cockpits#index'
#core routes
  resources :users
  resources :password_resets
  resources :sessions
  resources :cockpits
  resources :marketplaces
  resources :billings
  resources :settings
  resources :ssh_keys
  resources :cross_clouds
# the functional routes called by core
  resources :catalogs
  resources :onedews
  resources :oneapps
  resources :oneservice
  resources :oneaddons
# the routes used by the monitoring system
  resources :dashboards
  resources :widgets
  namespace :api do
    resources :dashboards do
      resources :widgets
    end
    match "data_sources/:kind" => "data_sources#index", via: [:get, :post]
  end
  namespace :api do
    match '/data_sources', to: 'data_sources#index', via: [:get, :post]
  end

# named route for users, session
  match '/signup', to: 'users#new', via: [:get]
  match '/signin', to: 'sessions#new', via: [:get]
  match '/tour', to: 'sessions#tour', via: [:get]
  match '/signout', to: 'sessions#destroy', via: [:post,:delete]
  match '/auth/facebook/callback', :to => 'sessions#create', via: [:get, :post]

# named rourte for billing, paid message callback from paypal or bitcoin
  match '/callback_url', to: 'billings#callback_url', via: [:get, :post]

# Generically handle errors for 404, 500.
  get "/404", :to => "errors#not_found"
  #get "/422", :to => "errors#unacceptable"
  get "/500", :to => "errors#internal_error"
# A visual designer route ? for what ?
  match '/varai', to: 'cockpit#varai', via: [:get]

end
