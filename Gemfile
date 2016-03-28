source 'https://rubygems.org'

def rails_master?
  ENV["RAILS_MASTER"] == '1'
end

if rails_master?
  gem 'arel', git: 'https://github.com/rails/arel.git'
  gem 'rails', git: 'https://github.com/rails/rails.git'
else
  gem 'rails', '~> 4.2'
end

#rails 4.2 transition
gem 'protected_attributes'
gem 'responders'

gem 'mail'

gem 'http_accept_language', '~>2.0.5', require: false

### Don't change the versions. henceforth just do a bundle install
gem 'ember-rails' , '0.18.2'
gem 'ember-source' , '1.12.2'
gem 'ember-data-source', "1.0.0.beta.16.1"
gem "ember-handlebars-template", '0.1.5'
gem 'barber', '0.9.0'
gem 'babel-transpiler', '0.7.0'

gem 'fast_xs'

gem 'fast_xor'

gem 'multi_json'
gem 'mustache'
gem 'nokogiri'

gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-github'
gem 'omniauth-oauth2', require: false
gem 'omniauth-google-oauth2'

# 3rd party system api's
gem 'megam_api'
gem 'github_api'
gem 'gitlab'
gem 'radosgw-s3'
gem 'randexp'
gem 'sshkey' # ssh key-gen

gem 'oj'
gem 'r2', '~> 0.2.5', require: false
gem 'rake'

gem 'rinku'
gem 'sanitize'
gem 'sass'

gem 'therubyracer'
gem 'rack-protection' # security


# Gems used only for assets and not required
# in production environments by default.
# allow everywhere for now cause we are allowing asset debugging in prd
group :assets do
  gem 'sass-rails', '~> 4.0.5'
  gem 'uglifier'
  gem 'rtlit', require: false # for css rtling
end

group :test do
  gem 'fakeweb', '~> 1.3.0', require: false
  gem 'minitest', require: false
end

group :test, :development do
  gem 'rspec', '~> 3.2.0'
  gem 'listen', '0.7.3', require: false
  gem 'certified', require: false
  gem 'fabrication', '2.9.8', require: false
  gem 'discourse-qunit-rails', require: 'qunit-rails'
  gem 'mocha', require: false
  gem 'rb-fsevent', require: RUBY_PLATFORM =~ /darwin/i ? 'rb-fsevent' : false
  gem 'rb-inotify', '~> 0.9', require: RUBY_PLATFORM =~ /linux/i ? 'rb-inotify' : false
  gem 'rspec-rails', require: false
  gem 'shoulda', require: false
  gem 'simplecov', require: false
  gem 'timecop'
  gem 'rspec-given'
  gem 'rspec-html-matchers'
  gem 'spork-rails'
  gem 'pry-nav'
  gem 'byebug', require: ENV['RM_INFO'].nil?
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'librarian', '>= 0.0.25', require: false
end

# this provides a very efficient lru cache
gem 'lru_redux'

# IMPORTANT: mini profiler monkey patches, so it better be required last
gem 'flamegraph', require: false
gem 'rack-mini-profiler', require: false

# passenger server
gem 'passenger', group: :production

gem 'rbtrace', require: false, platform: :mri

begin
  gem 'stackprof', require: false, platform: [:mri_21, :mri_22, :mri_23]
  gem 'memory_profiler', require: false, platform: [:mri_21, :mri_22, :mri_23]
rescue Bundler::GemfileError
  begin
    STDERR.puts "You are running an old version of bundler, please upgrade bundler ASAP."
    gem 'stackprof', require: false, platform: [:mri_21, :mri_22]
    gem 'memory_profiler', require: false, platform: [:mri_21, :mri_22]
  rescue Bundler::GemfileError
     gem 'stackprof', require: false, platform: [:mri_21]
     gem 'memory_profiler', require: false, platform: [:mri_21]
  end
end

gem 'rmmseg-cpp', require: false
