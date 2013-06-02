source 'https://rubygems.org'

# gem 'rails', '3.2.13'

# Bleeding edge : Rails 4.0 
gem "rails", "~> 4.0.0.rc1"
# add these gems to help with the transition to Rails 4.0
gem 'protected_attributes'
gem 'rails-observers'
gem 'actionpack-page_caching'
gem 'actionpack-action_caching'

#JQuery rails, other jquery scripts
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'execjs','1.4.0'
gem 'jquery-datatables-rails'
gem "flot-rails", "~> 0.0.3"
gem "gritter", "~> 1.0.3"

# Database posgresql
gem 'pg', '0.15.1'

# OAuth authentication to twitter, facebook, openid using omniauth
gem 'omniauth-twitter','0.0.16'
gem 'omniauth-facebook','1.4.1'
gem 'omniauth-openid','1.0.1'

gem 'will_paginate','3.0.4'
gem 'bootstrap-will_paginate','0.0.9'
gem 'paperclip','3.4.2'
gem "aws-sdk", "~> 1.11.0"
gem 'high_voltage',:git => 'https://github.com/thoughtbot/high_voltage.git'
gem "therubyracer", :require => 'v8',:platforms => :ruby

gem "breadcrumbs_on_rails"
gem "randexp", "~> 0.1.7"

#For background processing of cloud jobs
gem 'resque'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', :require => 'bcrypt'

# We may not use dynamodb. This isn't compatible with Rails4.0.
# Removing it for now.
# gem "dynamoid", '0.6.1'
# gem 'fake_dynamo', '~> 0.2.1'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'twitter-bootstrap-rails'

  # supporting rails 4.0
  gem 'sass-rails',   '~> 4.0.0.rc1'
  gem 'coffee-rails', '~> 4.0.0'

  #  gem 'sass-rails','3.2.6'
  #  gem 'coffee-rails','3.2.2'
  gem "less-rails", "~> 2.3.3"

   gem 'uglifier', '>= 2.1.0'
end

group :test do
  gem 'capybara','2.1.0'
  gem 'factory_girl_rails'
  gem 'cucumber-rails', :require => false
  gem "rspec-rails", "~> 2.13.1"
end

group :development do
  gem "rspec-rails", "~> 2.13.1"
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
end


# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
