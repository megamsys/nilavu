Cloudauth::Application.routes.draw do

  root :to => 'high_voltage/pages#show', :id => 'home'

  get "customizations/refresh"
  get "connector_actions/new"
  get "connector_actions/create"
  get "users/show"
  get "users/dashboard"



# 	=======Cloud_identity controller
  match '/federate', to: 'cloud_identities#federate'
  match '/cloud_identities/destroy', to: 'cloud_identities#destroy'
  match '/newidentity', to: 'cloud_identities#new_identity'

# 	=======Cloud Run
  match '/running_cloud', to: 'cloud_run#running_cloud'

# 	=======Billing conreoller
  match '/pricing', to: 'billing#pricing'
  match '/account', to: 'billing#account'
  match '/history', to: 'billing#history'

# 	=======apps_items_controller
  match '/apps_items/destroy', to: 'apps_items#destroy'

# 	=======Connector_project_controller
  match '/connector_project/destroy', to: 'connector_projects#destroy'
  match '/connector_project/create', to: 'connector_projects#create'
  match '/connector_project/upload', to: 'connector_projects#upload'
  match '/connector_project/import', to: 'connector_projects#import'
  match '/connector_execution/export', to: 'connector_executions#export'
  match '/connector_execution/execute', to: 'connector_executions#execute'


# 	=======Sample pages
  match 'pages/get_started' => 'high_voltage/pages#show', :id => 'get_started'
  match 'pages/features' => 'high_voltage/pages#show', :id => 'features'
  match 'pages/about' => 'high_voltage/pages#show', :id => 'about'
  match 'pages/contribute' => 'high_voltage/pages#show', :id => 'contribute'

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
  resources :cloud_run

#	======Users Controller
  match '/signup', to: 'users#new'
  match '/forgot', to: 'users#forgot'
  match '/update', to: 'users#update'
  match '/edit', to: 'users#edit'
  match '/dashboard', to: 'users#dashboard'
  match '/upgrade', to: 'users#upgrade'
  match '/email_verify', to: 'users#email_verify'
  match '/verified_email', to: 'users#verified_email'

  match '/signin', to: 'sessions#new'
  get "signout" => "sessions#destroy", :as => "signout"
  match '/signout', to: 'sessions#destroy', via: :delete

  match '/auth/:provider/callback', :to => 'sessions#create'

end
