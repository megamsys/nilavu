source 'https://rubygems.org'

gem "rails", "~> 4.1.2.rc3"
gem "sprockets", "~> 2.11.0"
# add these gems to help with the transition to Rails 4.x
gem 'protected_attributes', "~> 1.0.8"

# streaming
gem 'socket.io-rails', "~> 1.0.3"

#jquery & ui
gem 'jquery-rails', "~> 3.1.0"
gem 'twitter-bootstrap-rails', :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git', :branch => "bootstrap3"
gem 'turbolinks', "~> 2.2.2"
gem 'jquery-turbolinks',"~> 2.0.2"
gem 'jquery-ui-rails',"~> 4.2.1"
gem "icheck-rails","~> 0.9.0.2"
gem 'jquery-datatables-rails',"~> 1.12.2"
gem "flot-rails", "~> 0.0.6"
gem "gritter", "~> 1.1.0"
gem "flexslider","~> 2.2.0"
gem "masonry-rails", "~> 0.2.1"
gem "breadcrumbs", "~> 0.1.6"
gem 'remotipart', "~> 1.2.1"
gem 'sqlite3', "~> 1.3.9"

#fog
gem 'fog', "~> 1.22.1"

# db posgresql
#gem 'pg'

#group :production do
#  gem 'pg'
#end

#group :development, :test do

#end


# security and oauth
gem 'bcrypt', "~> 3.1.7"

gem 'oauth2', "~> 0.9.4"
gem 'oauth', "~> 0.4.7"
gem 'omniauth-oauth2', "~> 1.1.2"
gem 'omniauth-twitter', "~> 1.0.1"
gem 'omniauth-facebook', "~> 1.6.0"
gem "omniauth-google-oauth2", "~> 0.2.4"
gem 'omniauth-github', "~> 1.1.2"
gem "omniauth-assembla", "~> 0.0.3"

gem "aws-sdk", "~> 1.43.3"
gem 'json', "~> 1.8.1"

#general
gem "github_api", "~>0.11.3 "
gem 'twitter', "~> 5.10.0"
gem 'paperclip', "~> 4.1.1"
gem "randexp", "~> 0.1.7"
gem "megam_api", "~> 0.14"
gem "megam_scmmanager", "~> 0.1.0"
gem "megam_deccanplato", "~> 0.1.0"
gem "megam_assembla", "~> 0.1.0"
gem "inflector", "~> 0.0.1" #convert singularize
gem 'google-analytics-rails', '~> 0.0.6'


# http request and responses, http_proxy
gem "faraday", "~> 0.9.0"
gem "net-http-predicates", "~> 1.0.0" # [why can't we use faraday]
gem "httparty", "~> 0.13.1" # why can't we use faraday
gem "faraday_middleware", "~> 0.9.1"
gem "multi_xml", "~> 0.5.5"
gem "nokogiri", "~> 1.6.2.1"

gem 'unicorn', "~> 4.8.3",:group => :production
gem "therubyracer","~> 0.12.1", :require => 'v8',:platforms => :ruby

#ssh key-gen
gem "sshkey", "~> 1.6.1"

# Gems used only for assets and not required
# in production environments by default.
gem "less-rails", "~> 2.5.0"
gem 'sass-rails', "~> 4.0.3"
gem 'coffee-rails', "~> 4.0.1"
gem 'uglifier', "~> 2.5.1"


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
