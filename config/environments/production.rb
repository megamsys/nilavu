Nilavu::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  config.log_level = :info

  # Code is not reloaded between requests
  config.cache_classes = true
  config.eager_load = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_files = false
  #config.assets.js_compressor = :uglifier
  #To load angular
  config.assets.js_compressor = Uglifier.new(:mangle => false)

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = true

  config.assets.enabled = true

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

   config.assets.version = '1.0'

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # a comma delimited list of emails your devs have
  # developers have god like rights and may impersonate anyone in the system
  if emails = GlobalSetting.developer_emails
    config.developer_emails = emails.split(",").map(&:strip)
  end
end
