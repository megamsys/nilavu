require_dependency "homepage_constraint"

Nilavu::Application.routes.draw do
  resources :source_files, :only => [:index, :create, :destroy], :controller => 's3_uploads' do
    get :generate_key, :on => :collection
  end
  root to: 'cockpits#index'
  get '/404', to: 'errors#not_found'
  # get "/422", :to => "errors#unacceptable"
  get '/500', to: 'errors#internal_error'

  resources :users
  resources :sessions
  resources :cockpits
  resources :catalogs
  resources :marketplaces
  resources :ssh_keys
  resources :buckets
  resources :bucketkolkes
  resources :billings
  resources :onetorpedos
  resources :oneapps
  resources :oneservices
  resources :onemicroservices
  resources :phones
  resources :events   # Internal AJAX API

  # named route for users, session
  match '/signup', to: 'users#new', via: [:get]
  match '/signin', to: 'sessions#new', via: [:get]
  match '/tour', to: 'sessions#tour', via: [:get]
  match '/signout', to: 'sessions#destroy', via: [:post, :delete]
  post "forgot_password" => "session#forgot_password"
  get "password-reset/:token" => "users#password_reset"
  put "password-reset/:token" => "users#password_reset"

  match "/auth/:provider/callback", to: "omniauth_callbacks#complete", via: [:get, :post]
  match "/auth/failure", to: "users/omniauth_callbacks#failure", via: [:get, :post]

  get  "launchers/:id" => "launchers#launch"
  post "launchers" => "launchers#perform_launch"

  get "robots.txt" => "robots_txt#index"

  # named route for billing, paid message callback from paypal or bitcoin
  match '/billings_promo', to: 'billings#promo', via: [:get, :post]
  match '/invoice_pdf', to: 'billings#invoice_pdf', via: [:get, :post]
  match '/notify_payment', to: 'billings#notify_payment', via: [:get, :post]


  #=====github
  match '/publish_github', to: 'marketplaces#publish_github', via: [:get, :post]

  #=====Gitlab
  match 'store_gitlab', to: 'marketplaces#store_gitlab', via: [:post]
  match '/auth/gitlab',      to: 'marketplaces#start_gitlab', via: [:get, :post]
  match '/publish_gitlab',   to: 'marketplaces#publish_gitlab', via: [:get, :post]

  #===catalogs
  # kelvi   : confirm delete for all flycontrols. all cattypes will use that.
  match '/kelvi', to: 'catalogs#kelvi', via: [:post]
  match '/index', to: 'catalogs#index', via: [:get]

  #===Profiles
  match '/invite', to: 'users#invite', via: [:post]
  match '/accept_invite', to: 'users#accept_invite', via: [:get]

  #===One Overviews
  match '/bindservice', to: 'oneapps#show', via: [:get]

  #=== Notifications
  match '/sensors', to: 'sensors#index' , via: [:get, :post]
  #get 'notifications' => 'notifications#index'
  #put 'notifications/mark-read' => 'notifications#mark_read'

end
