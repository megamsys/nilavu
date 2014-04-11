Cloudauth::Application.routes.draw do
  get 'data_recovery/drbd_config'

  get 'oneapps/marketplaces'

  get 'oneapps/activities'

  get 'oneapps/settings'

  get 'oneapps/preclone'

  get 'oneapps/clone'

  root :to => 'cloud_dashboards#index', :id => 'signin'

  resources :users
  resources :sessions
  resources :identities
  resources :organizations, only: [:create, :destroy]
  resources :cloud_identities
  resources :apps_items
  resources :connector_projects
  resources :connector_actions
  resources :connector_outputs
  resources :connector_executions
  resources :apps_histories
  resources :apps #, via: [:get, :post, :destroy]
  resources :cross_clouds
  resources :cloud_stores
  resources :dashboards
  resources :widgets
  resources :password_resets
  resources :cloud_tool_settings
  resources :cloud_settings
  resources :marketplaces
  resources :cloud_dashboards
  resources :cloud_tool_settings
  resources :ssh_keys
  resources :addons

  namespace :api do
    resources :dashboards do
      resources :widgets
    end
    match "data_sources/:kind" => "data_sources#index", via: [:get, :post]
  end

  namespace :api do
    match '/data_sources', to: 'data_sources#index', via: [:get, :post]
  end

  
  #Cloud Books
  match '/launch', to: 'apps#launch', via: [:get, :post]
  match '/get_request', to: 'apps#get_request', via: [:get, :post]
  match '/build_request', to: 'apps#build_request', via: [:get, :post]
  match '/requests', to: 'oneapps#requests', via: [:get, :post]
  match '/activities', to: 'oneapps#activities', via: [:get, :post]
  
  match '/preclone', to: 'oneapps#preclone', via: [:get, :post]
  match '/clone', to: 'oneapps#clone', via: [:get, :post]
# to-do: move it as a static page for pricing.
  get '/pricing' => 'billing#pricing'
  # to-do: this is more like creating a new billing account
  get '/account' => 'billing#account'
  # to-do: this is showing the index of billed_history (make it a separate controller)
  get '/history' => 'billing#history'
  get '/upgrade' => 'billing#upgrade'
  # ...
  #mount Sidekiq::Web, at: '/worker'

 match '/reset', to: 'password_resets#reset', via: [:get, :post]

  #cloud_stores
  match '/new_store', to: 'cloud_stores#new_store', via: [:get, :post]

  # ======Users Controller
  match '/signup', to: 'users#new', via: [:get, :post]
  match '/forgot', to: 'users#forgot', via: [:get]
  match '/pass_email', to: 'users#pass_email', via: [:get, :post]
  match '/contact_us', to: 'users#contact', via: [:get, :post]
  #to-do remove the users#edit named route.
  match '/edit', to: 'users#edit',via: [:get]
  #to-do remove the users#update named route.
  match '/update', to: 'users#update', via: [:get, :post, :patch]
  match '/upgrade', to: 'users#upgrade', via: [:post]
  match '/email_verify', to: 'users#email_verify',via: [:get,:post]
  match '/verified_email', to: 'users#verified_email', via: [:get]
  match '/signin', to: 'sessions#new', via: [:get]
  match '/demo', to: 'sessions#demo', via: [:get]
  match '/signout', to: 'sessions#destroy', via: [:post,:delete]
  match '/auth/facebook/callback', :to => 'sessions#create', via: [:get, :post]
  match '/auth/github/callback', :to => 'apps#authorize_scm', via: [:get, :post]
  match '/auth/google_oauth2/callback', :to => 'cross_clouds#new', via: [:get, :post]
  match '/auth/assembla/callback', :to => 'apps#authorize_assembla', via: [:get, :post]
  match '/scm_manager_auth', :to => 'apps#scm_manager_auth', via: [:get, :post]
  match '/scmmanager_auth', :to => 'apps#scmmanager_auth', via: [:get, :post]
  match '/create_scm_user', :to => 'apps#create_scm_user', via: [:get, :post]
  # ======Dashboard
  get "users/show"
  #match '/dashboard_sidebar', to: 'dashboards#dashboard_sidebar', via: [:get]
  #match '/dashboards', to: 'dashboards#index', via: [:get]
  #match '/dashboards/:id' => 'dashboards#index', via: [:get]
 # match '/dashboards/:id', to: 'dashboards#index', via: [:get]
  #match '/dashboards/:id/:book', to: 'dashboards#index', via [:get]
  #match '/dashboards', to: 'users#dashboard',via: [:get]
  #match '/dashboards', to: 'api/dashboards#index',via: [:get]

  # ========Cloud Books Histories controller
  match '/node_log', to: 'apps_histories#logs', via: [:get, :post]

  # =======connector_project_ controller
  match '/deccanplato', to: 'connector_projects#deccanplato', via: [:get, :post]
  match '/import', to: 'connector_projects#import', via: [:get, :post]
  match '/resource', to: 'connector_projects#resource', via: [:get, :post]
  # match '/connector_project/destroy', to: 'connector_projects#destroy'
  # match '/connector_project/create', to: 'connector_projects#create'
  # match '/connector_project/upload', to: 'connector_projects#upload'
  # match '/connector_project/import', to: 'connector_projects#import'
  # match '/connector_execution/export', to: 'connector_executions#export'
  # match '/connector_execution/execute', to: 'connector_executions#execute'

  # ==========Cloud settings
  match '/cross_cloud_new', to: 'cloud_settings#cross_cloud_new', via: [:get, :post]
  match '/cross_cloud_create', to: 'cloud_settings#cross_cloud_create', via: [:get, :post]
  match '/cloud_tool_settings_create', to: 'cloud_settings#cloud_tool_setting_create', via: [:get, :post]
  match '/cloud_tool_setting_new', to: 'cloud_settings#cloud_tool_setting_new', via: [:get, :post]  
  match '/sshkeys_download', to: 'ssh_keys#download', via: [:get, :post] 
  match '/sshkey_create', to: 'cloud_settings#sshkey_create', via: [:get, :post] 
  match '/sshkey_import', to: 'ssh_keys#sshkey_import', via: [:get, :post] 
  match '/ssh_key_import', to: 'ssh_keys#ssh_key_import', via: [:get, :post]
  match '/selectclouds', to: 'cross_clouds#cloud_selector', via: [:get, :post]
  #get '/selectclouds' => 'cloud_settings#cloud_selector'
  #match '/selectclouds', to: 'cross_clouds#new', via: [:get, :post]
  #match '/market_place_app_show', to: 'marketplaces#market_place_app_show', via: [:get, :post]
  match '/changeversion', to: 'marketplaces#changeversion', via: [:get, :post]
  #Market place
  match '/category_view', to: 'marketplaces#category_view', via: [:get, :post]
  #Disaster Recovery
  match '/drbd_config', to: 'disaster_recovery#drbd_config', via: [:get, :post]
  match '/drbd_submit', to: 'disaster_recovery#drbd_submit', via: [:get, :post]
  
  # =======Error controller
  get "/404", :to => "errors#not_found"
  #get "/422", :to => "errors#unacceptable"
  get "/500", :to => "errors#internal_error"

  # =======Cloud_identity controller
  match '/federate', to: 'cloud_identities#federate', via: [:get, :post]
  #match '/identities/new', to: 'cloud_identities#', via: [:get, :post]

  # =======apps_items_controller
  match '/apps_items/destroy', to: 'apps_items#destroy', via: [:delete]
end
