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
  resources :oneservices
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

  # named route for billing, paid message callback from paypal or bitcoin
  match '/notify_payment', to: 'billings#notify_payment', via: [:get, :post]
  # Generically handle errors for 404, 500.
  get "/404", :to => "errors#not_found"
  #get "/422", :to => "errors#unacceptable"
  get "/500", :to => "errors#internal_error"
  # A visual designer route ? for what ?
  match '/varai', to: 'cockpit#varai', via: [:get]
  
  match '/billings_promo', to: 'billings#promo', via: [:get, :post]

  #=====github
  match '/auth/github/callback', :to => 'marketplaces#store_github', via: [:get, :post]
  match '/publish_github',       :to => 'marketplaces#publish_github', via: [:get, :post]

  #=====Gog
  match 'store_gogs',       :to => 'marketplaces#store_gogs', via: [:post]
  match '/auth/gogs',      :to => 'marketplaces#start_gogs', via: [:get, :post]
  match '/publish_gogs',   :to => 'marketplaces#publish_gogs', via: [:get, :post]

  #===catalogs
  # kelvi   : confirm delete for all flycontrols. all cattypes will use that.
  # logs    : logs widget for all the cattypes
  # runtime : runtime widget for all the cattypes (metering, metrics).
  match '/kelvi', :to => 'catalogs#kelvi', via: [:get]
  match '/logs', :to => 'catalogs#logs', via: [:get]
  match '/runtime', :to => 'catalogs#runtime', via: [:get]


end
