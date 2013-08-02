source 'https://rubygems.org'

# Rails 4.0
gem "rails", "~> 4.0.0"
# add these gems to help with the transition to Rails 4.0
gem 'protected_attributes'
gem 'rails-observers'
gem 'actionpack-page_caching'
gem 'actionpack-action_caching'

#gem "megam_api", "~> 0.1.0"
gem 'socket.io-rails'

#JQuery rails, other jquery scripts
gem 'turbolinks'
gem 'jquery-rails'
gem 'jquery-turbolinks'
gem 'jquery-ui-rails'
gem 'execjs','1.4.0'
gem 'jquery-datatables-rails'
gem "flot-rails", "~> 0.0.4"
gem "gritter", "~> 1.0.3"
gem "icheck-rails", "~> 0.9.0.2"

# Database posgresql
gem 'pg'

# OAuth authentication to twitter, facebook, openid using omniauth
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-openid'

gem 'will_paginate','3.0.4'
gem 'bootstrap-will_paginate','0.0.9'
gem 'paperclip','3.5.1'
gem "aws-sdk"
gem 'high_voltage',"1.2.4"
gem "therubyracer", :require => 'v8',:platforms => :ruby
gem "breadcrumbs_on_rails"
gem "randexp", "~> 0.1.7"
#For background processing of cloud jobs
gem 'resque'

# To use ActiveModel has_secure_password there is a hard dependency to 3.0.0 version.
# bummer.http://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html
gem 'bcrypt-ruby', '3.0.0',:require => 'bcrypt'

# We may not use dynamodb. This isn't compatible with Rails4.0.
# Removing it for now.
# gem "dynamoid", '0.6.1'
# gem 'fake_dynamo', '~> 0.2.1'

# Gems used only for assets and not required
# in production environments by default.
group :assets do

  gem 'twitter-bootstrap-rails'
  # supporting rails 4.0
  gem 'sass-rails',   '~> 4.0.0'
  gem 'coffee-rails', '~> 4.0.0'
  gem "less-rails", "~> 2.3.3"
  gem 'uglifier', '>= 2.1.2'
end

group :test do
  gem 'capybara','2.1.0'
  gem 'factory_girl_rails'
  gem 'cucumber-rails', :require => false
  gem "rspec-rails", "~> 2.14.0"
end

group :development do
  gem "rspec-rails", "~> 2.14.0"
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
end

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
