source 'https://rubygems.org'

#rails 4.1.x (bleeding edge)
gem "rails", "~> 4.1.0.beta1"
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
gem 'jquery-datatables-rails', git: 'git://github.com/rweng/jquery-datatables-rails.git'
gem "flot-rails", "~> 0.0.4"
gem "gritter", "~> 1.0.3"
gem "flexslider", "~> 2.0.2"
gem 'will_paginate','3.0.5'
gem 'bootstrap-will_paginate','0.0.10'
gem "breadcrumbs"
gem 'remotipart'

# db posgresql
gem 'pg'

# security and oauth
gem 'bcrypt-ruby',:require => 'bcrypt'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem "omniauth-google-oauth2"
gem 'omniauth-github'

#general
gem "github_api"
gem 'twitter'
gem 'paperclip','3.5.2'
gem "aws-sdk"
gem "randexp", "~> 0.1.7"
gem "megam_api"
gem "megam_deccanplato"
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
gem "less-rails", "~> 2.4.2"
gem 'sass-rails',   '~> 4.0.1'
gem 'coffee-rails', '~> 4.0.1'
gem 'uglifier', '>= 2.4.0'


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
