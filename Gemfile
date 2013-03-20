source 'https://rubygems.org'

gem 'rails', '3.2.13'
# Bleeding edge : Rails 4.0 : This has problems due to Dynamoid not support Observers.
# Somebody is free to sent a pull request.
#gem "rails", "~> 4.0.0.beta1"

#JQuery rails, other jquery scripts
gem 'jquery-rails','2.2.1'
gem 'jquery-ui-rails'
gem 'execjs','1.4.0'
gem 'jquery-datatables-rails'
gem "flot-rails", "~> 0.0.2"
gem "gritter", "~> 1.0.3"
# Database posgresql
gem 'pg', '0.14.1'
# OAuth authentication to twitter, facebook, openid using omniauth
gem 'omniauth-twitter','0.0.14'
gem 'omniauth-facebook','1.4.1'
gem 'omniauth-openid','1.0.1'
gem 'will_paginate','3.0.4'
gem 'bootstrap-will_paginate','0.0.9'
gem 'paperclip','3.4.1'
gem "aws-sdk", "~> 1.8.5"
gem 'high_voltage','1.2.2'
gem "therubyracer", :require => 'v8',:platforms => :ruby
gem "dynamoid", '0.6.1'
gem 'fake_dynamo', '~> 0.1.1'
gem "breadcrumbs_on_rails"
gem "randexp", "~> 0.1.7"
#For background processing of cloud jobs
gem 'resque'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', :require => 'bcrypt'
#gem 'less-rails', '~> 2.2.6' #for using mailer. Without this shows error as method missing 'less'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'twitter-bootstrap-rails'
  # supporting rails 4.0
  #gem "sass-rails", "~> 4.0.0.beta1"
  #gem "coffee-rails", "~> 4.0.0.beta1"

  gem 'sass-rails','3.2.6'
  gem 'coffee-rails','3.2.2'
  gem "less-rails", "~> 2.3.2"

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '>= 1.3.0'
end

group :test do
  gem 'capybara','2.0.2'
  gem 'factory_girl_rails'
  gem 'cucumber-rails', :require => false
  gem "rspec-rails", "~> 2.13.0"
end

group :development do
  gem "rspec-rails", "~> 2.13.0"
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
end

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
