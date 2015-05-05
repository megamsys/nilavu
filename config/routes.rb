Nilavu::Application.routes.draw do

  get 'delete/SCMs'

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
  resources :apps #, via: [:get, :post, :destroy]
  resources :services
  resources :dews
  resources :addons
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

  # ======Users Controller
  match '/signup', to: 'users#new', via: [:get]
  match '/signin', to: 'sessions#new', via: [:get]
  match '/tour', to: 'sessions#tour', via: [:get]
  match '/signout', to: 'sessions#destroy', via: [:post,:delete]
  match '/auth/facebook/callback', :to => 'sessions#create', via: [:get, :post]

  #Market place
  match '/products', to: 'marketplaces#products', via: [:get, :post]
  #billings
  match '/callback_url', to: 'billings#callback_url', via: [:get, :post]

  #cockpit, controls [CREATE, DELETE] catcontrols [START, STOP ..RESTART of a catalog]
  match '/controls', to: 'cockpits#controls', via: [:post]
  match '/catcontrols', to: 'cockpits#catcontrols', via: [:post]

  # =======Error controller
  get "/404", :to => "errors#not_found"
  #get "/422", :to => "errors#unacceptable"
  get "/500", :to => "errors#internal_error"
  match '/varai', to: 'cockpit#varai', via: [:get]

end
