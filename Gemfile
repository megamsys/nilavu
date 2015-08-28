source "https://rubygems.org"
#ruby "2.2.2"

gem "rails",  "~> 4.2.3"
# add these gems to help with the transition to Rails 4.2.x
gem 'protected_attributes', "~> 1.1.0"
gem "responders", "~> 2.1.0"

#jquery & ui
gem 'jquery-rails', "~> 4.0.4"
gem 'turbolinks', "~> 2.5.3"
gem 'jquery-turbolinks',"~> 2.1.0"
gem 'remotipart', "~> 1.2.1" #ajax sfile uploads
gem 'socket.io-rails', "~> 1.3.6" # streaming
gem 'nprogress-rails' #spinner youtube like

# security and oauth
gem 'bcrypt', "~> 3.1.10"

gem 'oauth2', "~> 1.0.0"
gem 'oauth', "~> 0.4.7"
gem 'omniauth-oauth2', "~> 1.3.1"
gem 'omniauth-facebook', "~> 2.0.1"
gem "omniauth-google-oauth2", "~> 0.2.6"
gem 'omniauth-github', "~> 1.1.2"

gem 'json', "~> 1.8.3"
gem 'riak-client', '~> 2.2.1'

gem "megam_api", "~> 0.63"
gem 'megam_gogs', "~> 0.8.0"

gem 'gitlab', '~> 3.4.0'

#general
gem "github_api", "~>0.12.4"
gem "randexp", "~> 0.1.7"
gem 'google-analytics-rails', '~> 0.0.6'
gem "paypal-sdk-rest", "~>1.3.1" #billing
gem "sshkey", "~> 1.7.0" #ssh key-gen
gem "settingslogic" #singleton settings yaml manager

# http request and responses, http_proxy
gem "faraday", "~> 0.9.1"
gem "faraday_middleware", "~> 0.10.0"
gem "nokogiri", "~> 1.6.6.2"

gem 'passenger',:group => :production

gem 'sass-rails', "~> 5.0.3"
gem 'uglifier', "~> 2.7.1"

gem "therubyracer","~> 0.12.2", :require => 'v8',:platforms => :ruby

group :test do
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'cucumber-rails', :require => false
end

group :development do
  gem "rspec-rails"
end
