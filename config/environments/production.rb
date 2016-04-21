Nilavu::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  config.log_level = :debug

  # Code is not reloaded between requests
  config.cache_classes = true
  config.eager_load = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_files = GlobalSetting.serve_static_assets

  config.assets.js_compressor = :uglifier
  #config.assets.js_compressor = Uglifier.new(:mangle => false)

  config.assets.css_compressor = :sass

  # stuff should be pre-compiled
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  config.log_level = :info


  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # this will cause all handlebars templates to be pre-compiles, making your page faster
  config.handlebars.precompile = true

  # allows developers to use mini profiler
  config.load_mini_profiler = GlobalSetting.load_mini_profiler

  # a comma delimited list of emails your devs have
  # developers have god like rights and may impersonate anyone in the system
  # normal admins may only impersonate other moderators (not admins)
  if emails = GlobalSetting.developer_emails
    config.developer_emails = emails.split(",").map(&:strip)
  end
end
