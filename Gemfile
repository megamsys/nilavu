source 'https://rubygems.org'
# ruby "2.3.0"

#core ruby
gem 'json', '~> 1.8.3'
gem 'net-ssh'
gem 'net-ping'

#rails
gem 'rails', '~> 4.2.5'
gem 'rails-i18n', '~> 4.0.8'
gem 'protected_attributes', '~> 1.1.3' # transition to rails 4.2.x
gem 'responders', '~> 2.1.1' # transition to rails 4.2.x

# ui - (sass, react, growl, websocket)
gem 'jquery-rails', '~> 4.0.5'
gem 'turbolinks', '~> 2.5.3'
gem 'jquery-turbolinks', '~> 2.1.0'
gem 'react-rails', '~> 1.5.0'
gem 'sass-rails', '~> 5.0.4'
gem 'remotipart', '~> 1.2.1' # ajax file uploads (sshkey)
gem 'socket.io-rails', '~> 1.4.4' # websocket streaming
gem 'nprogress-rails' # youtube like spinner
gem 'toastr_rails'
gem 'zeroclipboard-rails', '~> 0.1.1'
gem 'uglifier', '~> 2.7.2'
gem 'therubyracer', '~> 0.12.2', require: 'v8', platforms: :ruby

# security
gem 'oauth2', '~> 1.0.0'
gem 'oauth', '~> 0.4.7'
gem 'omniauth-oauth2', '~> 1.3.1'
gem 'omniauth-facebook', '~> 3.0.0'
gem 'omniauth-google-oauth2', '~> 0.2.10'
gem 'omniauth-github', '~> 1.1.2'

# 3rd party system api's
gem 'megam_api', '~>0.93'
gem 'github_api', '~>0.13.1'
gem 'gitlab', '~> 3.6.1'
gem 'riak-client', '~> 2.3.2'
gem 'radosgw-s3'
gem 'mailgunner'
gem 'http'

gem 'google-analytics-rails', '~> 0.0.6'
gem 'paypal-sdk-rest', '~>1.3.4' # billing

# general misc helper
gem 'randexp', '~> 0.1.7'
gem 'sshkey',  '~> 1.8.0' # ssh key-gen
gem 'settingslogic' # singleton settings yaml manager
gem 'rubysl-base64', '~> 2.0'

# passenger server
gem 'passenger', group: :production

group :test do
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'fakes3'
end

group :development do
  gem 'rspec-rails'
  gem 'quiet_assets'
  gem 'rubocop', require: false
end
