source 'https://rubygems.org'
# ruby "2.2.2"

# ruby
gem 'json', '~> 1.8.3'
gem 'net-ssh'

gem 'rails', '~> 4.2.4'
gem 'rails-i18n', '~> 4.0.5' # For 4.0.x
gem 'protected_attributes', '~> 1.1.3' # transition to rails 4.2.x
gem 'responders', '~> 2.1.0' # transition to rails 4.2.x

# ui - (sass, react, growl, websocket)
gem 'jquery-rails', '~> 4.0.5'
gem 'turbolinks', '~> 2.5.3'
gem 'jquery-turbolinks', '~> 2.1.0'
gem 'react-rails', '~> 1.3.2'
gem 'sass-rails', '~> 5.0.4'
gem 'remotipart', '~> 1.2.1' # ajax file uploads (sshkey)
gem 'socket.io-rails', '~> 1.3.7' # websocket streaming
gem 'nprogress-rails' # youtube like spinner
gem 'gritter', '~> 1.2.0'
gem 'uglifier', '~> 2.7.2'
gem 'therubyracer', '~> 0.12.2', require: 'v8', platforms: :ruby

# security
gem 'bcrypt', '~> 3.1.10'
gem 'oauth2', '~> 1.0.0'
gem 'oauth', '~> 0.4.7'
gem 'omniauth-oauth2', '~> 1.3.1'
gem 'omniauth-facebook', '~> 2.0.1'
gem 'omniauth-google-oauth2', '~> 0.2.8'
gem 'omniauth-github', '~> 1.1.2'

# 3rd party system api's
gem 'megam_api', '~> 0.73'
gem 'megam_gogs', '~> 0.8.0'
gem 'github_api', '~>0.12.4'
gem 'gitlab', '~> 3.4.0'
gem 'riak-client', '~> 2.2.1'
gem 'radosgw-s3'
gem 'google-analytics-rails', '~> 0.0.6'
gem 'paypal-sdk-rest', '~>1.3.1' # billing

# general misc helper
gem 'randexp', '~> 0.1.7'
gem 'sshkey', '~> 1.7.0' # ssh key-gen
gem 'settingslogic' # singleton settings yaml manager

# passenger server
gem 'passenger', group: :production

group :test do
  gem 'capybara'
  gem 'factory_girl_rails'
end

group :development do
  gem 'rspec-rails'
  gem 'quiet_assets'
  gem 'awesome_print', require: 'ap'
end
