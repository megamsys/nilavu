require_dependency "homepage_constraint"

Nilavu::Application.routes.draw do
  resources :source_files, :only => [:index, :create, :destroy], :controller => 's3_uploads' do
    get :generate_key, :on => :collection
  end
  root to: 'cockpits#index'
  get '/404', to: 'errors#not_found'
  get '/500', to: 'errors#internal_error'

  resources :users
  resources :sessions
  resources :cockpits
  resources :catalogs
  resources :marketplaces
  resources :ssh_keys
  resources :buckets
  resources :bucketfiles
  resources :onetorpedos
  resources :oneapps
  resources :oneservices
  resources :onemicroservices
  resources :phones

  # named route for users, session
  match '/signup', to: 'users#new', via: [:get]
  match '/signin', to: 'sessions#new', via: [:get]
  match '/tour', to: 'sessions#tour', via: [:get]
  match '/signout', to: 'sessions#destroy', via: [:post, :delete]
  post  'forgot_password' => "session#forgot_password"
  get   "password-reset/:token" => "users#password_reset"
  put   "password-reset/:token" => "users#password_reset"

  match "/auth/:provider/callback", to: "omniauth_callbacks#complete", via: [:get, :post]
  match "/auth/failure", to: "omniauth_callbacks#failure", via: [:get, :post]

  get  "launchers/:id" => "launchers#launch"
  post "launchers" => "launchers#perform_launch"

  get "robots.txt" => "robots_txt#index"
  #git
  get "github/repos" => "github#list", constraints: { format: /(json|html)/}
  get "auth/gitlab" => "gitlab#show", constraints: { format: /(json|html)/}
  get "gitlab/repos" => "gitlab#list", constraints: { format: /(json|html)/}

  #catalogs
  match '/kelvi', to: 'catalogs#kelvi', via: [:post]
  match '/index', to: 'catalogs#index', via: [:get]

  #ceph
  get   '/cephsignin', to: 'cephs#create', constraints: HomePageConstraint.new
  post  '/cephsignin', to: 'cephs#create', constraints: HomePageConstraint.new
  get   '/cephsignup', to: 'ceph_users#create', constraints: HomePageConstraint.new
  post  '/cephsignup', to: 'ceph_users#create', constraints: HomePageConstraint.new
end
