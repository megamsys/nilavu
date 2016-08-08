require File.expand_path('../boot', __FILE__)
require 'action_controller/railtie'
require 'active_support/dependencies'

# Global config
require_relative '../app/models/global_setting'

if defined?(Bundler)
  Bundler.require(*Rails.groups(assets: %w(development test)))
end

module Nilavu
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    require 'nilavu'
    require 'es6_module_transpiler/rails'
    require 'js_locale_helper'

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += Dir["#{config.root}/app/serializers"]
    config.autoload_paths += Dir["#{config.root}/lib"]
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.autoload_paths += Dir["#{Rails.root}/lib/validators"]
    config.autoload_paths += Dir["#{config.root}/app"]

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    config.assets.paths += %W(#{config.root}/config/locales #{config.root}/public/javascripts)

    # Allows us to skip minifincation on some files
    config.assets.skip_minification = []

    # explicitly precompile any images ( /assets/images ) path
    config.assets.precompile += [lambda do |filename, path|
      path =~ /assets\/images/ && !%w(.js .css).include?(File.extname(filename))
    end]

    config.assets.precompile += ['vendor.js', 'common.css', 'desktop.css', 'shiny/shiny.css',
                                'admin.js', 'preload_store.js', 'browser-update.js', 'embed.css', 'break_string.js',
                                'ember_jquery.js']

    # Precompile all defer
    Dir.glob("#{config.root}/app/assets/javascripts/defer/*.js").each do |file|
      config.assets.precompile << "defer/#{File.basename(file)}"
    end

    # Precompile all available locales
    Dir.glob("#{config.root}/app/assets/javascripts/locales/*.js.erb").each do |file|
      config.assets.precompile << "locales/#{file.match(/([a-z_A-Z]+\.js)\.erb$/)[1]}"
    end

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'UTC'

    # auto-load locales in plugins
    # NOTE: we load both client & server locales since some might be used by PrettyText
    config.i18n.load_path += Dir["#{Rails.root}/plugins/*/config/locales/*.yml"]

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = 'utf-8'

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [
        :password,
        :pop3_polling_password,
        :ceph_secret_access_key,
        :facebook_app_secret,
        :github_client_secret
    ]

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.1'

    # per https://www.owasp.org/index.php/Password_Storage_Cheat_Sheet
    config.pbkdf2_iterations = 64000
    config.pbkdf2_algorithm = "sha256"

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

    # route all exceptions via our router
    config.exceptions_app = self.routes

    # Our templates shouldn't start with 'nilavu/templates'
    config.handlebars.templates_root = 'nilavu/templates'
    config.handlebars.raw_template_namespace = "Ember.TEMPLATES"

    config.cache_store = :file_store, "#{ENV['MEGAM_HOME']}/nilavu/cache"

    # we configure rack cache on demand in an initializer
    # our setup does not use rack cache and instead defers to nginx
    config.action_dispatch.rack_cache =  nil

    # ember stuff only used for asset precompliation, production variant plays up
    config.ember.variant = :development
    config.ember.ember_location = "#{Rails.root}/vendor/assets/javascripts/production/ember.js"
    config.ember.handlebars_location = "#{Rails.root}/vendor/assets/javascripts/handlebars.js"

    require 'auth'

    if GlobalSetting.relative_url_root.present?
      config.relative_url_root = GlobalSetting.relative_url_root
    end

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

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

#if defined?(PhusionPassenger)
#  PhusionPassenger.on_event(:starting_worker_process) do |forked|
#    if forked
#      Nilavu.after_fork
#    end
#  end
#end
