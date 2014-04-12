source 'https://rubygems.org'

gem "rails", "~> 4.1.0"
# add these gems to help with the transition to Rails 4.x
gem 'protected_attributes', :git => "git://github.com/rails/protected_attributes.git"

# streaming
gem 'socket.io-rails'

#jquery & ui
gem 'jquery-rails'
gem 'twitter-bootstrap-rails', :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git', :branch => "bootstrap3"
gem 'turbolinks'
gem 'jquery-turbolinks'
gem 'jquery-ui-rails'
gem "icheck-rails"
gem 'jquery-datatables-rails'
gem "flot-rails", "~> 0.0.4"
gem "gritter", "~> 1.1.0"
gem "flexslider","~> 2.2.0"
gem "masonry-rails"
gem 'will_paginate'
gem 'bootstrap-will_paginate'
gem "breadcrumbs"
gem 'remotipart'

#fog
gem 'fog'

# db posgresql
gem 'pg'

# security and oauth
gem 'bcrypt-ruby',:require => 'bcrypt'
gem 'oauth2'
gem 'oauth'
gem 'omniauth-oauth2'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem "omniauth-google-oauth2"
gem 'omniauth-github'
gem "omniauth-assembla"

gem "aws-sdk"
gem 'json'

#general
gem "github_api"
gem 'twitter'
gem 'paperclip'
gem "randexp", "~> 0.1.7"
gem "megam_api"
gem "megam_scmmanager"
gem "megam_deccanplato"
gem "megam_assembla"
gem "inflector" #convert singularize
gem "cheddargetter_client_ruby" #chettargetter API
gem 'google-analytics-rails', '~> 0.0.4'


# http request and responses, http_proxy
gem "faraday"
gem "net-http-predicates" # [why can't we use faraday]   
gem "httparty" # why can't we use faraday
gem "faraday_middleware"
gem "multi_xml"
gem "nokogiri"

gem 'unicorn', :group => :production
gem "therubyracer", :require => 'v8',:platforms => :ruby

#ssh key-gen
gem "sshkey"

# Gems used only for assets and not required
# in production environments by default.
gem "less-rails"
gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'


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
