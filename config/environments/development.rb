Nilavu::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.eager_load = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Do not compress assets
  config.assets.compress = false

  # Don't Digest assets, makes debugging uglier
  config.assets.digest = false

  config.assets.debug = false

  # Log level to debug
  config.log_level = :debug

  config.watchable_dirs['lib'] = [:rb]

  config.sass.debug_info = false
  config.handlebars.precompile = false

  config.load_mini_profiler = true


  require 'rbtrace'

  if emails = GlobalSetting.developer_emails
    config.developer_emails = emails.split(",").map(&:strip)
  end
end
