require_dependency "homepage_constraint"
require_dependency "permalink_constraint"

Nilavu::Application.routes.draw do

  get '/404', to: 'errors#not_found'
  get "/404-body" => "exceptions#not_found_body"
  get '/500', to: 'errors#internal_error'


  GROUPNAME_ROUTE_FORMAT = /[\w.\-]+/ unless defined? GROUPNAME_ROUTE_FORMAT

  # named route for users, session
  resources :static
  post "login" => "static#enter"
  get "login" => "static#show", id: "login"
  get "password-reset" => "static#show", id: "password_reset"
  get "signup" => "static#show", id: "signup"
  get "torpedo.json" => 'cockpits#index', defaults: {format: 'json'}

  #session related
  resources :sessions
  get "session/csrf" => "sessions#csrf"
  post "forgot_password" => "sessions#forgot_password"
  get "/password_reset" => "users#password_reset"
  put "/password_reset" => "users#password_reset"
  get "users/account-created/" => "users#account_created"

  match "/auth/:provider/callback", to: "omniauth_callbacks#complete", via: [:get, :post]
  match "/auth/failure", to: "omniauth_callbacks#failure", via: [:get, :post]

  resources :users, except: [:show, :update, :destroy] do
    collection do
      get "check_email"
    end
  end

  get "users/:id.json" => 'users#show', defaults: {format: 'json'}
  get 'users/:id/:username' => 'users#show'

  get "stylesheets/:name.css" => "stylesheets#show", constraints: { name: /[a-z0-9_]+/ }

  get "launchables.json" => 'launchables#assemble', defaults: {format: 'json'}
  get "launchables/pools/:group_name.json" => "launchables#prepare", as: "launchables_pools_group", constraints: {
    group_name: GROUPNAME_ROUTE_FORMAT
  }

  get "launchables/summary.json" => "launchables#summarize", as: "launchables_summarize"

  ##
  get  "launchers/:id.json" => "launchers#launch"
  post "launchers.json" => "launchers#perform_launch"

  get "/ssh_keys/edit/:name", to: "ssh_keys#edit"

  get 'notifications' => 'notifications#index'
  put 'notifications/mark-read' => 'notifications#mark_read'

  ##
  get "robots.txt" => "robots_txt#index"
  get "manifest.json" => "manifest_json#index", :as => :manifest

  root to: 'cockpits#entrance', :as => "entrance"

  get "*url", to: 'permalinks#show', constraints: PermalinkConstraint.new
end
