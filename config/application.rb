require File.expand_path('../boot', __FILE__)
require 'action_controller/railtie'
require 'active_support/dependencies'
require 'rails/test_unit/railtie'
require 'sprockets/railtie'

# Global config
require_relative '../app/models/global_setting'


# COMMON YML
if defined?(Bundler)
  Bundler.require(*Rails.groups(assets: %w(development test)))
end

module Nilavu
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    require 'nilavu'


    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    # Autoload lib/ folder including all subdirectories
    config.autoload_paths += Dir["#{config.root}/lib"]
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.autoload_paths += Dir["#{Rails.root}/lib"]
    config.autoload_paths += Dir["#{Rails.root}/lib/**/"]
    config.autoload_paths += %W(#{config.root}/lib/gitlab.rb)

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
    config.encoding = 'utf-8'

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [
      :password,
      :pop3_polling_password,
      :s3_secret_access_key,
      :twitter_consumer_secret,
      :facebook_app_secret,
      :github_client_secret
    ]

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    # config.active_record.whitelist_attributes = true

    # Enable the asset pipeline
    config.assets.enabled = true

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # to ignore the internationalization for English
    config.i18n.available_locales = :en

    # 404 catcher
    config.after_initialize do |app|
      app.routes.append { match '*a', to: 'application#render_404', via: [:get] } unless config.consider_all_requests_local
    end
    # rack lock is nothing but trouble, get rid of it
    # for some reason still seeing it in Rails 4
    config.middleware.delete Rack::Lock

    # ETags are pointless, we are dynamically compressing
    # so nginx strips etags, may revisit when mainline nginx
    # supports etags (post 1.7)
    config.middleware.delete Rack::ETag
    # we configure rack cache on demand in an initializer
    # our setup does not use rack cache and instead defers to nginx
    config.action_dispatch.rack_cache =  nil

    puts "=> MEGAM_HOME env: #{ENV['MEGAM_HOME']}."

    require 'auth'
    # generate banner text - http://patorjk.com/software/taag/#p=display&f=ANSI%20Shadow&t=Nilavu
    # generate banner text - http://patorjk.com/software/taag/#p=display&f=ANSI%20Shadow&t=Nilavu
    puts ''"\033[1m\033[32m
                  _..._       ███╗   ██╗██╗██╗      █████╗ ██╗   ██╗██╗   ██╗
                .::'   `.     ████╗  ██║██║██║     ██╔══██╗██║   ██║██║   ██║
               :::       :    ██╔██╗ ██║██║██║     ███████║██║   ██║██║   ██║
               :::       :    ██║╚██╗██║██║██║     ██╔══██║╚██╗ ██╔╝██║   ██║
               `::.     .'    ██║ ╚████║██║███████╗██║  ██║ ╚████╔╝ ╚██████╔╝
                 `':..-'      ╚═╝  ╚═══╝╚═╝╚══════╝╚═╝  ╚═╝  ╚═══╝   ╚═════╝
  \033[0m"''
    if ENV['RBTRACE'] == "1"
      require 'rbtrace'
    end

  end
end
