#require 'sidekiq/web'
Cloudauth::Application.routes.draw do

  get "contents/header"

  root :to => 'high_voltage/pages#show', :id => 'home'

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
  resources :cloud_books_histories
  resources :cloud_books
  resources :predef_clouds
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

  # =======Static pages served via high_voltage
  get 'pages/get_started' => 'high_voltage/pages#show', :id => 'get_started'
  get 'pages/features' => 'high_voltage/pages#show', :id => 'features'
  get 'pages/about' => 'high_voltage/pages#show', :id => 'about'
  get 'pages/contribute' => 'high_voltage/pages#show', :id => 'contribute'
  # to-do: move it as a static page for pricing.
  get '/pricing' => 'billing#pricing'
  # to-do: this is more like creating a new billing account
  get '/account' => 'billing#account'
  # to-do: this is showing the index of billed_history (make it a separate controller)
  get '/history' => 'billing#history'

  #users
  match '/worker', to: 'users#worker', via: [:get, :post]

  #Cloud Books
  match '/new_book', to: 'cloud_books#new_book', via: [:get, :post]

  # ...
  #mount Sidekiq::Web, at: '/worker'

  # ======Users Controller
  match '/signup', to: 'users#new', via: [:get, :post]
  match '/forgot', to: 'users#forgot', via: [:get, :post]
  match '/contact_us', to: 'users#contact', via: [:get, :post]
  #to-do remove the users#edit named route.
  match '/edit', to: 'users#edit',via: [:get]
  #to-do remove the users#update named route.
  match '/update', to: 'users#update', via: [:get, :post, :patch]
  match '/upgrade', to: 'users#upgrade', via: [:post]
  match '/email_verify', to: 'users#email_verify',via: [:get,:post]
  match '/verified_email', to: 'users#verified_email', via: [:get]
  match '/signin', to: 'sessions#new', via: [:get]
  match '/signout', to: 'sessions#destroy', via: [:post,:delete]
  match '/auth/:provider/callback', :to => 'sessions#create', via: [:get, :post]

  # ======Dashboard
  get "users/show"
  #match '/dashboards', to: 'dashboards#index', via: [:get]
  #match '/dashboards/:id', to: 'dashboards#index', via: [:get]
  #match '/dashboards/:id/:book', to: 'dashboards#index', via [:get]
  #match '/dashboards', to: 'users#dashboard',via: [:get]
  #match '/dashboards', to: 'api/dashboards#index',via: [:get]

  # ========Cloud Books Histories controller
  match '/node_log', to: 'cloud_books_histories#logs', via: [:get, :post]

  # =======connector_project_ controller
  match '/deccanplato', to: 'connector_projects#deccanplato', via: [:get, :post]
  match '/import', to: 'connector_projects#import', via: [:get, :post]
  #  match '/connector_project/destroy', to: 'connector_projects#destroy'
  #  match '/connector_project/create', to: 'connector_projects#create'
  #  match '/connector_project/upload', to: 'connector_projects#upload'
  #  match '/connector_project/import', to: 'connector_projects#import'
  #  match '/connector_execution/export', to: 'connector_executions#export'
  #  match '/connector_execution/execute', to: 'connector_executions#execute'

  #   =======Error controller
  get "/404", :to => "errors#not_found"
  #get "/422", :to => "errors#unacceptable"
  get "/500", :to => "errors#internal_error"

  # =======Cloud_identity controller
  match '/federate', to: 'cloud_identities#federate', via: [:get, :post]
  #match '/identities/new', to: 'cloud_identities#', via: [:get, :post]

  # =======apps_items_controller
  match '/apps_items/destroy', to: 'apps_items#destroy', via: :delete

end
