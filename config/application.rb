require File.expand_path('../boot', __FILE__)
require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
#  Bundler.require(:default, Rails.env)
# was used by Rails 3.2
Bundler.require(*Rails.groups(:assets => %w(development test)))
# If you want your assets lazily compiled in production, use this line
# Bundler.require(:default, :assets, Rails.env)
end

module Cloudauth
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    # Autoload lib/ folder including all subdirectories
    config.autoload_paths += Dir["#{config.root}/lib", "#{config.root}/lib/**/", "#{Rails.root}/lib", "#{Rails.root}/lib/**/"]

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Kolkata'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    # config.active_record.whitelist_attributes = true

     #Enable the asset pipeline
    config.assets.enabled = true

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # 404 catcher
    config.after_initialize do |app|
      app.routes.append{ match '*a', :to => 'application#render_404', via: [:get] } unless config.consider_all_requests_local
    end
    
    config.ganglia_web_url  = ENV['GANGLIA_WEB_URL']
    config.ganglia_host     = ENV['GANGLIA_HOST']
    config.ganglia_base_url = "http://monitor.megam.co/ganglia"
    config.ganglia_cluster = 'EC2'
    config.ganglia_graph_metric  = 'cpu_system'
    config.ganglia_request_metric = 'nginx_requests'
    #config.ganglia_request_metric = 'nginx_status'
    config.metric_source = 'demo'
    config.payment_gateway = 'demo'



config.assets.precompile << Proc.new do |path|
  if path =~ /\.(css|js)\z/
    full_path = Rails.application.assets.resolve(path).to_path
    app_assets_path = Rails.root.join('app', 'assets').to_path
    if full_path.starts_with? app_assets_path
      puts "including asset: " + full_path
      true
    else
      puts "excluding asset: " + full_path
      false
    end
  else
    false
  end
end


  end
end
