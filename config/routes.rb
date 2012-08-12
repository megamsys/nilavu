Cloudauth::Application.routes.draw do

  get "customizations/show"

  root :to => 'high_voltage/pages#show', :id => 'home'
  
  match 'pages/get_started' => 'high_voltage/pages#show', :id => 'get_started'
  match 'pages/doc' => 'high_voltage/pages#show', :id => 'doc'
  match 'pages/about' => 'high_voltage/pages#show', :id => 'about'
  match 'pages/contribute' => 'high_voltage/pages#show', :id => 'contribute'
    
  resources :users
  resources :sessions
  resources :identities
  resources :organizations, only: [:create, :destroy]
  

  match '/signup',  to: 'users#new'

  match '/update',  to: 'users#update'

  match '/edit',  to: 'users#edit'

  match '/signin',  to: 'sessions#new'
  get "signout" => "sessions#destroy", :as => "signout"
  match '/signout', to: 'sessions#destroy', via: :delete

  match '/auth/:provider/callback', :to => 'sessions#create'

end
