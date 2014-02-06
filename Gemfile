source 'https://rubygems.org'

gem "rails", "~> 4.0.2"
# add these gems to help with the transition to Rails 4.0
gem 'protected_attributes'
gem 'rails-observers'
gem 'actionpack-page_caching'
gem 'actionpack-action_caching'
gem 'socket.io-rails'
gem 'google-analytics-rails', '~> 0.0.4'
#JQuery rails, other jquery scripts
gem 'turbolinks'
gem 'jquery-rails'
gem 'jquery-turbolinks'
gem 'jquery-ui-rails'
gem 'jquery-datatables-rails'
gem "flot-rails", "~> 0.0.4"
gem "gritter", "~> 1.0.3"
gem "flexslider", "~> 2.0.2"
gem 'unicorn', :group => :production

gem "github_api"

# Database posgresql
gem 'pg'
gem 'twitter'

# OAuth authentication to twitter, facebook, github, google using omniauth
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem "omniauth-google-oauth2"
gem 'omniauth-github'

gem 'will_paginate','3.0.5'
gem 'bootstrap-will_paginate','0.0.10'
gem 'paperclip','3.5.2'
gem "aws-sdk"
gem "therubyracer", :require => 'v8',:platforms => :ruby
gem "breadcrumbs_on_rails"
gem "randexp", "~> 0.1.7"
gem "megam_api"
gem "megam_deccanplato"
#password
gem 'bcrypt-ruby',:require => 'bcrypt'

gem 'remotipart'

#http_proxy settings
gem "faraday"
gem "faraday_middleware"
gem "multi_xml"
#net-http request and responses, [why can't we use faraday] 
gem "net-http-predicates"  
gem "icheck-rails"

#html parsing
gem "nokogiri"

#convert singularize
gem "inflector"

#chettargetter API
gem "cheddargetter_client_ruby"
gem "httparty" # why can't we use faraday

#ssh key-gen
gem "sshkey"

# Gems used only for assets and not required
# in production environments by default.
  #gem 'twitter-bootstrap-rails'
 gem 'twitter-bootstrap-rails', :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git', :branch => "bootstrap3"
  gem "less-rails", "~> 2.4.2"
#group :assets do
  gem 'sass-rails',   '~> 4.0.1'
  gem 'coffee-rails', '~> 4.0.1'
  gem 'uglifier', '>= 2.4.0'
#end

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

#For background processing of cloud jobs
#gem 'resque'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
