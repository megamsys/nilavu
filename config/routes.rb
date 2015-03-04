Cloudauth::Application.routes.draw do
  get 'data_recovery/drbd_config'

  get 'oneapps/marketplaces'

  get 'oneapps/activities'

  get 'oneapps/settings'

  get 'oneapps/preclone'

  get 'oneapps/clone'

  root :to => 'main_dashboards#index', :id => 'signin'


  resources :users
  resources :sessions
  resources :identities
  resources :apps_histories
  resources :apps #, via: [:get, :post, :destroy]
  resources :cross_clouds
  resources :services
  resources :dashboards
  resources :widgets
  resources :password_resets
  resources :settings
  resources :marketplaces
  resources :main_dashboards
  resources :ssh_keys
  resources :addons
  resources :oneaddons
  resources :oneapps
  resources :oneservice

  namespace :api do
    resources :dashboards do
      resources :widgets
    end
    match "data_sources/:kind" => "data_sources#index", via: [:get, :post]
  end

  namespace :api do
    match '/data_sources', to: 'data_sources#index', via: [:get, :post]
  end

 match '/edituser' => 'users#edituser', via: [:get, :post]
 match '/userupdate' => 'users#userupdate', via: [:put]
 
#oneapp Overview
  match '/appoverview', to: 'oneapps#overview', via: [:get, :post]
  match '/appruntime', to: 'oneapps#runtime', via: [:get, :post]
  match '/applogs', to: 'oneapps#logs', via: [:get, :post]
  match '/oneapp_services', to: 'oneapps#services', via: [:get, :post]
  
  
  #oneservice Overview
  match '/serviceoverview', to: 'oneservice#overview', via: [:get, :post]
  match '/serviceruntime', to: 'oneservice#runtime', via: [:get, :post]
  match '/servicelogs', to: 'oneservice#logs', via: [:get, :post]
  match '/oneservice_services', to: 'oneservice#services', via: [:get, :post]
  
  #oneaddons Overview
  match '/addonsoverview', to: 'oneaddons#overview', via: [:get, :post]
  match '/addonsruntime', to: 'oneaddons#runtime', via: [:get, :post]
  match '/addonslogs', to: 'oneaddons#logs', via: [:get, :post]
  match '/oneaddons_services', to: 'oneaddons#services', via: [:get, :post]
  
  #Cloud Books
  match '/starter_packs_launch', to: 'marketplaces#starter_packs_create', via: [:get, :post]
  match '/byoc_launch', to: 'marketplaces#byoc_create', via: [:get, :post]
  match '/app_boilers_launch', to: 'marketplaces#app_boilers_create', via: [:get, :post]
  match '/addons_launch', to: 'marketplaces#addons_create', via: [:get, :post]
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


  #services
  match '/new_store', to: 'services#new_store', via: [:get, :post]

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
  match '/auth/github/callback', :to => 'marketplaces#github_scm', via: [:get, :post]
  match '/github_call', :to => 'marketplaces#github_sessions_data', via: [:get, :post]
  match '/auth/google_oauth2/callback', :to => 'cross_clouds#gwindow', via: [:get, :post]
  match '/auth/assembla/callback', :to => 'apps#authorize_assembla', via: [:get, :post]
  match '/github_ajax', :to => 'marketplaces#github_sessions', via: [:get, :post]
  match '/scm_manager_auth', :to => 'apps#scm_manager_auth', via: [:get, :post]
  match '/scmmanager_auth', :to => 'apps#scmmanager_auth', via: [:get, :post]
  match '/create_scm_user', :to => 'apps#create_scm_user', via: [:get, :post]
  # ======Dashboard
  get "users/show"
  get "oneapps/show"
  get "oneservice/show"
  get "oneaddons/show"
 
  #match '/dashboard_sidebar', to: 'dashboards#dashboard_sidebar', via: [:get]
  #match '/dashboards', to: 'dashboards#index', via: [:get]
  #match '/dashboards/:id' => 'dashboards#index', via: [:get]
 # match '/dashboards/:id', to: 'dashboards#index', via: [:get]
  #match '/dashboards/:id/:book', to: 'dashboards#index', via [:get]
  #match '/dashboards', to: 'users#dashboard',via: [:get]
  #match '/dashboards', to: 'api/dashboards#index',via: [:get]

match '/delete_request', :to => 'main_dashboards#delete_request', via: [:get, :post]

 #DenselyPacked app lifecycle 
 match '/lifecycle', :to => 'main_dashboards#lifecycle', via: [:get] 
 match '/deleteapp', :to => 'main_dashboards#deleteapp', via: [:get]
 match '/lifecycle_request', :to => 'main_dashboards#lifecycle_request', via: [:get, :post]
 
 
 #one app lifecycle 
 match '/lcapp', :to => 'oneapps#lcapp', via: [:get] 
 match '/app_request', :to => 'oneapps#app_request', via: [:get, :post] 
 match '/bind_service_list', :to => 'oneapps#bind_service_list', via: [:get]
 match '/bindService', :to => 'oneapps#bindService', via: [:get]
 
 #one service lifecycle 
 match '/lcservice', :to => 'oneservice#lcservice', via: [:get] 
 match '/service_request', :to => 'oneservice#service_request', via: [:get, :post]
 
 #one addon lifecycle
 match '/lcaddon', :to => 'oneaddons#lcaddon', via: [:get] 
 match '/addon_request', :to => 'oneaddons#addon_request', via: [:get, :post]
 

  # ========Cloud Books Histories controller
  match '/logs', to: 'apps_histories#logs', via: [:get, :post]

  # ==========Cloud settings
  match '/cross_cloud_new', to: 'settings#cross_cloud_new', via: [:get, :post]
  match '/cross_cloud_create', to: 'settings#cross_cloud_create', via: [:get, :post]
  match '/cloud_tool_settings_create', to: 'settings#cloud_tool_setting_create', via: [:get, :post]
  match '/cloud_tool_setting_new', to: 'settings#cloud_tool_setting_new', via: [:get, :post]  
  match '/sshkeys_download', to: 'ssh_keys#download', via: [:get, :post] 
  match '/sshkey_create', to: 'settings#sshkey_create', via: [:get, :post] 
  match '/sshkey_import', to: 'ssh_keys#sshkey_import', via: [:get, :post] 
  match '/ssh_key_import', to: 'ssh_keys#ssh_key_import', via: [:get, :post]
  match '/cloud_selector', to: 'cross_clouds#cloud_selector', via: [:get, :post]
  match '/cloud_init', to: 'cross_clouds#cloud_init', via: [:get, :post]
  #get '/selectclouds' => 'settings#cloud_selector'
  #match '/selectclouds', to: 'cross_clouds#new', via: [:get, :post]
  #match '/market_place_app_show', to: 'marketplaces#market_place_app_show', via: [:get, :post]
  match '/changeversion', to: 'marketplaces#changeversion', via: [:get, :post]
  #Market place
  match '/category_view', to: 'marketplaces#category_view', via: [:get, :post]
  #Disaster Recovery
  match '/drbd_config', to: 'disaster_recovery#drbd_config', via: [:get, :post]
  match '/drbd_submit', to: 'disaster_recovery#drbd_submit', via: [:get, :post]
    match '/view_details', to: 'cross_clouds#view_details', via: [:get, :post] 
    
    #=====Gog
    match '/gogs', to: 'marketplaces#gogs', via: [:get, :post]
   # match '/gogs_return', to: 'marketplaces#gogs_return', via: [:get, :post]
  post 'trigger', :to => 'marketplaces#gogs_return', via: [:post]
  match '/gogs_popup', :to => 'marketplaces#gogswindow', via: [:get, :post]
  #root :to => 'marketplaces#gogswindow'
  # =======Error controller
  get "/404", :to => "errors#not_found"
  #get "/422", :to => "errors#unacceptable"
  get "/500", :to => "errors#internal_error"

 
  match '/visualCallback', to: 'main_dashboards#visualCallback', via: [:get]
  
end
