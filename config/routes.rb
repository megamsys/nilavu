Cloudauth::Application.routes.draw do

  root :to => 'main_dashboards#index'
  match '/delete_request', :to => 'main_dashboards#delete_request', via: [:get, :post]	#Used in maindashboard_index.html.erb
  match '/lifecycle', :to => 'main_dashboards#lifecycle', via: [:get]
  match '/deleteapp', :to => 'main_dashboards#deleteapp', via: [:get]

  resources :users
  resources :sessions
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
  resources :vms
  resources :onevms
  resources :billings


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
  match '/forgot', to: 'users#forgot', via: [:get]
  match '/signin', to: 'sessions#new', via: [:get]
  match '/tour', to: 'sessions#tour', via: [:get]
  match '/signout', to: 'sessions#destroy', via: [:post,:delete]
  match '/auth/facebook/callback', :to => 'sessions#create', via: [:get, :post]
  match '/auth/google_oauth2/callback', :to => 'cross_clouds#gwindow', via: [:get, :post]
  match '/auth/assembla/callback', :to => 'apps#authorize_assembla', via: [:get, :post]


  #oneapp Overview
  match '/appoverview', to: 'oneapps#overview', via: [:get, :post]
  match '/appruntime', to: 'oneapps#runtime', via: [:get, :post]
  match '/applogs', to: 'oneapps#logs', via: [:get, :post]
  match '/oneapp_services', to: 'oneapps#services', via: [:get, :post]

  #one app lifecycle
  match '/lcapp', :to => 'oneapps#lcapp', via: [:get]
  match '/app_request', :to => 'oneapps#app_request', via: [:get, :post]
  match '/bind_service_list', :to => 'oneapps#bind_service_list', via: [:get]
  match '/bindService', :to => 'oneapps#bindService', via: [:get]

  #oneservice Overview
  match '/serviceoverview', to: 'oneservice#overview', via: [:get, :post]
  match '/serviceruntime', to: 'oneservice#runtime', via: [:get, :post]
  match '/servicelogs', to: 'oneservice#logs', via: [:get, :post]
  match '/oneservice_services', to: 'oneservice#services', via: [:get, :post]

  #one service lifecycle
  match '/lcservice', :to => 'oneservice#lcservice', via: [:get]
  match '/service_request', :to => 'oneservice#service_request', via: [:get, :post]

  #oneaddons Overview
  match '/addonsoverview', to: 'oneaddons#overview', via: [:get, :post]
  match '/addonsruntime', to: 'oneaddons#runtime', via: [:get, :post]
  match '/addonslogs', to: 'oneaddons#logs', via: [:get, :post]
  match '/oneaddons_services', to: 'oneaddons#services', via: [:get, :post]
  #one addon lifecycle
  match '/lcaddon', :to => 'oneaddons#lcaddon', via: [:get]
  match '/addon_request', :to => 'oneaddons#addon_request', via: [:get, :post]


  #vm Overview
  match '/vmoverview', to: 'onevms#overview', via: [:get, :post]
  match '/vmlogs', to: 'onevms#logs', via: [:get, :post]
  #one instance lifecycle
  match '/vm_request', :to => 'onevms#vm_request', via: [:get, :post]


  #market place items
  match '/starter_packs_launch', to: 'marketplaces#starter_packs_create', via: [:get, :post]
  match '/byoc_launch', to: 'marketplaces#byoc_create', via: [:get, :post]
  match '/app_boilers_launch', to: 'marketplaces#app_boilers_create', via: [:get, :post]
  match '/addons_launch', to: 'marketplaces#addons_create', via: [:get, :post]
  match '/instances_launch', to: 'marketplaces#instances_create', via: [:get, :post]
  #Market place
  match '/category_view', to: 'marketplaces#category_view', via: [:get, :post]
  #billings
  match '/callback_url', to: 'billings#callback_url', via: [:get, :post]
  #gogs
  match '/gogs', to: 'marketplaces#gogs', via: [:get, :post]
  match '/gogs_return', to: 'marketplaces#gogs_return', via: [:get, :post]
  post 'trigger', :to => 'marketplaces#gogs_return', via: [:post]
  match '/auth/gogs', :to => 'marketplaces#gogswindow', via: [:get, :post]
  match '/gogs_call', :to => 'marketplaces#gogs_sessions', via: [:get, :post]
  #github
  match '/auth/github/callback', :to => 'marketplaces#github_scm', via: [:get, :post]
  match '/github_ajax', :to => 'marketplaces#github_sessions', via: [:get, :post]
  match '/github_call', :to => 'marketplaces#github_sessions_data', via: [:get, :post]


  # ==========Cloud settings
  match '/cross_cloud_new', to: 'settings#cross_cloud_new', via: [:get, :post]
  match '/cross_cloud_create', to: 'settings#cross_cloud_create', via: [:get, :post]
  match '/sshkeys_download', to: 'ssh_keys#download', via: [:get, :post]
  match '/sshkey_create', to: 'settings#sshkey_create', via: [:get, :post]
  match '/sshkey_import', to: 'ssh_keys#sshkey_import', via: [:get, :post]
  match '/ssh_key_import', to: 'ssh_keys#ssh_key_import', via: [:get, :post]
  match '/cloud_selector', to: 'cross_clouds#cloud_selector', via: [:get, :post]
  match '/cloud_init', to: 'cross_clouds#cloud_init', via: [:get, :post]
  match '/changeversion', to: 'marketplaces#changeversion', via: [:get, :post]
 match '/view_details', to: 'cross_clouds#view_details', via: [:get, :post]



  # =======Error controller
  get "/404", :to => "errors#not_found"
  #get "/422", :to => "errors#unacceptable"
  get "/500", :to => "errors#internal_error"
  match '/visualCallback', to: 'main_dashboards#visualCallback', via: [:get]

end
