source 'https://rubygems.org'

gem "rails",  "~> 4.2.0"
# add these gems to help with the transition to Rails 4.2.x
gem 'protected_attributes', "~> 1.0.8"
gem "responders", "~> 2.0.2"

# streaming
gem 'socket.io-rails', "~> 1.2.1"

#jquery & ui
gem 'jquery-rails', "~> 4.0.3"
gem "font-awesome-rails", "3.2.1.3"
gem 'turbolinks', "~> 2.5.3"
gem 'jquery-turbolinks',"~> 2.1.0"
gem 'remotipart', "~> 1.2.1"

#AJAX for file uploads
#Added //= require jquery.remotipart in application.js

#fog
gem 'fog', "~> 1.26.0"
gem 'opennebula'

# security and oauth
gem 'bcrypt', "~> 3.1.9"

gem 'oauth2', "~> 1.0.0"
gem 'oauth', "~> 0.4.7"
gem 'omniauth-oauth2', "~> 1.2.0"
gem 'omniauth-twitter', "~> 1.1.0"
gem 'omniauth-facebook', "~> 2.0.0"
gem "omniauth-google-oauth2", "~> 0.2.6"
gem 'omniauth-github', "~> 1.1.2"
gem "omniauth-assembla", "~> 0.0.3"

gem 'json', "~> 1.8.1"
gem 'riak-client', '~> 2.1.0'


#general
gem "github_api", "~>0.12.2"
gem 'twitter', "~> 5.11.0"
gem "randexp", "~> 0.1.7"
gem "megam_api", "~> 0.31"
gem "megam_scmmanager", "~> 0.1.0"
gem "megam_deccanplato", "~> 0.1.0"
gem "megam_assembla", "~> 0.1.0"
gem 'google-analytics-rails', '~> 0.0.6'
gem 'megam_gogs', "~> 0.3.0"



# http request and responses, http_proxy
gem "faraday", "~> 0.9.0"
gem "faraday_middleware", "~> 0.9.1"
gem "nokogiri", "~> 1.6.5"

gem 'unicorn', "~> 4.8.3",:group => :production
gem "therubyracer","~> 0.12.1", :require => 'v8',:platforms => :ruby

#ssh key-gen
gem "sshkey", "~> 1.6.1"

# Gems used only for assets and not required
# in production environments by default.
gem "less-rails", "~> 2.6.0"
gem 'sass-rails', "~> 5.0.1"
gem 'coffee-rails', "~> 4.1.0"
gem 'uglifier', "~> 2.6.0"

group :test do
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'cucumber-rails', :require => false
end

group :development do
  gem "rspec-rails"
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
end
