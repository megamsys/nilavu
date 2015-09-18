Nilavu::Application.routes.draw do



  get 'storages/index'

  root :to => 'cockpits#index'
  #core routes
  resources :users
  resources :password_resets
  resources :sessions
  resources :cockpits
  resources :marketplaces
  resources :storages
  resources :billings
  resources :settings
  resources :ssh_keys
  resources :cross_clouds
  # the functional routes called by core
  resources :catalogs
  resources :onetorpedos
  resources :oneapps
  resources :oneservices
  resources :onemicroservices
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
  match '/auth/facebook/callback', :to => 'sessions#callbacks', via: [:get, :post]
  match '/auth/google_oauth2/callback', :to => 'sessions#callbacks', via: [:get, :post]


  # named route for billing, paid message callback from paypal or bitcoin
  match '/notify_payment', to: 'billings#notify_payment', via: [:get, :post]
  # Generically handle errors for 404, 500.
  get "/404", :to => "errors#not_found"
  #get "/422", :to => "errors#unacceptable"
  get "/500", :to => "errors#internal_error"
  # A visual designer route ? for what ?
  match '/varai', to: 'cockpit#varai', via: [:get]

  match '/billings_promo', to: 'billings#promo', via: [:get, :post]

  match '/storages', to: 'storages#index', via: [:get, :post]

  #=====github
  match '/auth/github/callback', :to => 'marketplaces#store_github', via: [:get, :post]
  match '/social_create', :to => 'sessions#create', via: [:get, :post]

  match '/publish_github',       :to => 'marketplaces#publish_github', via: [:get, :post]

  #=====Gogs
  match 'store_gogs',       :to => 'marketplaces#store_gogs', via: [:post]
  match '/auth/gogs',      :to => 'marketplaces#start_gogs', via: [:get, :post]
  match '/publish_gogs',   :to => 'marketplaces#publish_gogs', via: [:get, :post]

  #=====Gitlab
  match 'store_gitlab',       :to => 'marketplaces#store_gitlab', via: [:post]
  match '/auth/gitlab',      :to => 'marketplaces#start_gitlab', via: [:get, :post]
  match '/publish_gitlab',   :to => 'marketplaces#publish_gitlab', via: [:get, :post]

  #===catalogs
  # kelvi   : confirm delete for all flycontrols. all cattypes will use that.
  # logs    : logs widget for all the cattypes
  # runtime : runtime widget for all the cattypes (metering, metrics).
  match '/kelvi', :to => 'catalogs#kelvi', via: [:post]
  match '/logs', :to => 'catalogs#logs', via: [:get]
  match '/runtime', :to => 'catalogs#runtime', via: [:get]
  match '/index', :to => 'catalogs#index', via: [:get]

  #===OneApps
  match '/bind_service_list', :to => 'oneapps#bind_service_list', via: [:get, :post]
  match '/bind_service', :to => 'oneapps#bind_service', via: [:get, :post]


end
