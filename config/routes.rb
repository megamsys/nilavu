Cloudauth::Application.routes.draw do

  get "connector_actions/new"

  get "connector_actions/create"

  get "customizations/show"

  get "users/show"
 
  get "organizations/show_api_token"
  get "organizations/create_api_access_key"
  
match '/email_verify', to: 'users#email_verify'
match '/verified_email', to: 'users#verified_email'

match '/apps_items/destroy', to: 'apps_items#destroy'
match '/connector_project/destroy', to: 'connector_projects#destroy'
match '/connector_project/create', to: 'connector_projects#create'
match '/connector_project/upload', to: 'connector_projects#upload'
match '/connector_project/import', to: 'connector_projects#import'
match '/connector_execution/export', to: 'connector_executions#export'
match '/connector_execution/execute', to: 'connector_executions#execute' 
 

  root :to => 'high_voltage/pages#show', :id => 'home'

  match 'pages/get_started' => 'high_voltage/pages#show', :id => 'get_started'
  match 'pages/doc' => 'high_voltage/pages#show', :id => 'doc'
  match 'pages/about' => 'high_voltage/pages#show', :id => 'about'
  match 'pages/contribute' => 'high_voltage/pages#show', :id => 'contribute'
 
  
  resources :users
  resources :sessions
  resources :identities
  resources :organizations, only: [:create, :destroy]
  resources :cloud_identities
  resources :cloud_apps
  resources :apps_items
  resources :connectors
  resources :connector_projects
  resources :connector_actions
  resources :connector_outputs
  resources :connector_executions


 
  
  match '/signup',  to: 'users#new'

  match '/forgot',  to: 'users#forgot'
  match '/calendar', to: 'users#calendar'

  match '/update',  to: 'users#update'

  match '/edit',  to: 'users#edit'
  
  match '/unicorn_index', to: 'users#unicorn_index'

  match '/signin',  to: 'sessions#new'
  get "signout" => "sessions#destroy", :as => "signout"
  match '/signout', to: 'sessions#destroy', via: :delete

  match '/auth/:provider/callback', :to => 'sessions#create'
  
  

end
